extends Node2D

signal hit # TODO: rename this to "dead"?
signal apple_eaten

var source_id     : int = 0
var snakeTiles    : Array[SnakeTile] # The array of the snake's tiles
var appleCoords   : Vector2i         # The coordinate of the apple tile
var direction     : Vector2          # The direction of the snake's head
var new_direction : Vector2          # The new direction for the snake's head

var layers : Array[TileMapLayer]


## ---------- High-Level Behaviour Functions ----------- ##

# Called when the node enters the scene tree for the first time.
func _ready():
	stop_ticker()
	snakeTiles  = []
	appleCoords = Vector2i(-1, -1)
	
	# TODO: This was implemented this way to allow the smoothest transition from 4.2's TileMap to
	# 4.3's TileMapLayer system. It may need to be changed to work a little differently.
	layers = [
		get_node("Background"),
		get_node("Game Level"),
		get_node("Snake"),
		get_node("Foreground")
	]
	
	layers[SnakeTile.Layer.FG].modulate = Color.GRAY


# TODO: descriptor
func spawn_new_snake():
	
	# Clear any old snake tiles that exist
	clear_snake_and_apple()
	var snake_layer:TileMapLayer = get_node("Snake")
	snake_layer.modulate = Color.WHITE
	
	# Set the snake and apple to their starting positions
	direction     = Vector2.RIGHT
	new_direction = Vector2.RIGHT
	snakeTiles = [
		SnakeTile.new("head", Vector2i(10,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("body", Vector2i(9,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("body", Vector2i(8,10),  Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("tail", Vector2i(7,10),  Vector2.RIGHT, Vector2.LEFT),
	]
	renderNewSnake()
	set_apple_cell()

# TODO: descriptor
func start_ticker():
	# TODO: This feels extremely inefficient. Find a way to wait for the first
	# player input that doesn't involve a conditional checked with every single
	# player input
	$Ticker.start()

# TODO: Descriptor
func kill_snake():
	# TODO: Maybe set the alt_id for the head in this func?
	layers[SnakeTile.Layer.SNAKE].modulate = Color.GRAY

# TODO: Descriptor
func update_mode():
	
	# Set the TileMap source ID
	if Global.worm_mode:
		source_id = 1
	else:
		source_id = 0
	
	# Refresh all the cells on all layers
	for layer in layers:
		var layer_cell_coords = layer.get_used_cells()
		for cell_coords in layer_cell_coords:
			layer.set_cell(
				cell_coords, 
				source_id, 
				layer.get_cell_atlas_coords(cell_coords), 
				layer.get_cell_alternative_tile(cell_coords)
			)


## ----------- Child Node Behaviour Functions ---------- ##

# TODO: Descriptor
func stop_ticker():
	if !$Ticker.is_stopped():
		$Ticker.stop()

# TODO: Descriptor
func update_score(score:int):
	$HUD.update_score(score)

# TODO: Descriptor
func update_high_score(high_score:int):
	$HUD.update_high_score(high_score)

func new_high_score():
	$NewHighScore.temporarily_activate(get_head_tile_screen_pos())

func worm_mode_unlocked():
	$WormModeUnlocked.temporarily_activate(get_head_tile_screen_pos())

## ------------- Snake Rendering Functions ------------- ##

# TODO: Descriptor
func renderNewSnake():
	for s in snakeTiles:
		set_snake_cell(s)


## ------------- Snake Movement Functions -------------- ##

# TODO: Descriptor
func turn_head(input_direction : Vector2): 
	if direction.dot(input_direction) == 0:
		new_direction = input_direction

# TODO: Descriptor
# TODO: Maybe this should be moved to the main scene...
func _on_ticker_timeout():
	
	if new_direction != direction:
		# TODO: Given the existance of this signal, it REALLY feels like this func should be in Main...
		#turn.emit()
		direction = new_direction
	
	moveSnake()

# TODO: Descriptor
func moveSnake(): 
	
	# Build the new coordinates for the head tile
	var newHeadCoord = snakeTiles[0].get_coords() + Vector2i(direction)
	
	# Move the snake according to what sort of tile it's about to run into:
	
	# Case where the snake eats the apple
	if cell_is_apple(newHeadCoord):
		move_head(newHeadCoord)
		set_apple_cell()
		apple_eaten.emit()
	
	# Case where the snake hits nothing
	elif cell_is_empty(newHeadCoord) || cell_is_tail(newHeadCoord) :
		move_tail()
		move_head(newHeadCoord)
	
	# Case where the snake something that is not an apple
	else:
		move_tail()
		move_head(newHeadCoord, true)
		hit.emit()
		return

# TODO: descriptor
func move_head(newHeadCoord : Vector2i, dead : bool = false):
	
	# Change the old head tile to be a body tile facing the new direction
	snakeTiles[0].set_atlas_coords("body")
	snakeTiles[0].set_direction(direction, snakeTiles[0].get_back_dir())
	
	# Add the new head tile
	var newHeadTile : SnakeTile
	if !dead: 
		newHeadTile = SnakeTile.new("head", newHeadCoord, direction, direction.rotated(PI))
	else: 
		newHeadTile = SnakeTile.new("dead_head", newHeadCoord, direction, direction.rotated(PI))
	snakeTiles.push_front(newHeadTile)
	
	# Render the updated cells
	set_snake_cell(snakeTiles[0])
	set_snake_cell(snakeTiles[1])

# TODO: descriptor
func move_tail():
	
	# Change the new tail tile to be a tail tile facing the same direction
	snakeTiles[-2].set_atlas_coords("tail")
	snakeTiles[-2].set_direction(snakeTiles[-2].get_front_dir(), snakeTiles[-2].get_front_dir().rotated(PI))
	
	# Remove the old tail tile
	var oldTailCoords = snakeTiles.pop_back().get_coords()
	
	# Render the updated cells
	set_snake_cell(snakeTiles[-1])
	layers[SnakeTile.Layer.SNAKE].erase_cell(oldTailCoords)

# TODO: Descriptor
func clear_snake_and_apple():
	
	# Clear the snake tiles
	for s in snakeTiles:
		layers[s.get_layer()].erase_cell(s.get_coords())
	snakeTiles = []
	
	# Clear the apple tile
	layers[SnakeTile.Layer.LEVEL].erase_cell(appleCoords)
	appleCoords = Vector2i(-1,-1)


## --------------- Cell Setter Functions --------------- ##

# TODO: Descriptor
func set_snake_cell(snake_tile : SnakeTile):
	layers[snake_tile.get_layer()].set_cell(snake_tile.get_coords(), source_id, snake_tile.get_atlas_coords(), snake_tile.get_alt_id())

# TODO: Descriptor
func set_apple_cell():
	
	# Remove The old apple
	layers[SnakeTile.Layer.LEVEL].erase_cell(appleCoords)
	
	# TODO: This will potentially slow the game down in later stages of the game. Maybe think
	# of a more CPU-friendly implementation? 
	while true:
		appleCoords = Vector2i(randi_range(1,16), randi_range(2,17))
		if layers[SnakeTile.Layer.SNAKE].get_cell_tile_data(appleCoords) == null:
			break
	
	layers[SnakeTile.Layer.LEVEL].set_cell(appleCoords, source_id, SnakeTile.APPLE_ATLAS)


## ----------------- Getters Functions ----------------- ##

func cell_is_apple(coords : Vector2i) -> bool:
	return coords == appleCoords

func cell_is_empty(coords : Vector2i) -> bool:
	var level_layer_data = layers[SnakeTile.Layer.LEVEL].get_cell_tile_data(coords)
	var snake_layer_data = layers[SnakeTile.Layer.SNAKE].get_cell_tile_data(coords)
	return level_layer_data == null && snake_layer_data == null

func cell_is_tail(coords : Vector2i) -> bool:
	return layers[SnakeTile.Layer.SNAKE].get_cell_atlas_coords(coords) == SnakeTile.TAIL_ATLAS

# get_head_tile_screen_pos returns the screen position coordinates of the center
# of the snake's head tile.
func get_head_tile_screen_pos() -> Vector2 :
	return Vector2(snakeTiles[0].get_coords()*layers[SnakeTile.Layer.BG].rendering_quadrant_size) + Vector2(0.5,0.5)*layers[SnakeTile.Layer.BG].rendering_quadrant_size

# is_turning returns true if the snake is about to turn.
func is_turning() -> bool: 
	return direction != new_direction

func is_waiting() -> bool:
	return $Ticker.is_stopped()
