extends Node2D

signal dead
signal apple_eaten
signal game_tick

var source_id     : int = 0                     # The source ID for the tile atlas (to allow switch to and from WORM MODE)
var snake_tiles   : Array[SnakeTile]            # The array of the snake's tiles
var apple_coords  : Vector2i = Vector2i(-1,-1)  # The coordinate of the apple tile
var direction     : Vector2                     # The direction of the snake's head
var new_direction : Vector2                     # The new direction for the snake's head

# The array of TileMapLayers on the game board.
#
# Note: This was implemented this way to allow the smoothest transition from 4.2's TileMap to
# 4.3's TileMapLayer system. In future versions of this project, it may be refactored to
# something more suitable.
var layers : Array[TileMapLayer]

func _ready():
	
	# Setup the layer array
	layers = [
		get_node("Background"),
		get_node("Game Level"),
		get_node("Snake"),
		get_node("Foreground")
	]
	
	# Modulate the foreground layer to Gray since it's exclusively for the dead snake head.
	layers[SnakeTile.Layer.FG].modulate = Color.GRAY

	# Boot the scene in an empty state
	clear_game()


## ---------- Game-Ticker Behaviour Functions ---------- ##

func start_ticker():
	$Ticker.start()

func stop_ticker():
	$Ticker.stop()

func _on_ticker_timeout():
	game_tick.emit()

func ticker_is_stopped() -> bool:
	return $Ticker.is_stopped()


## ---------- High-Level Behaviour Functions ----------- ##

# clear_game resets the entire game to its empty state, with no snake, no apple, and no
# game-ticks.
func clear_game():
	
	# Stop the game-ticker
	$Ticker.stop()
	
	# Clear the snake tiles
	for s in snake_tiles:
		layers[s.get_layer()].erase_cell(s.get_coords())
	snake_tiles = []
	
	# Reset the Snake ties' color
	layers[SnakeTile.Layer.SNAKE].modulate = Color.WHITE
	
	# Clear the apple tile
	layers[SnakeTile.Layer.LEVEL].erase_cell(apple_coords)
	apple_coords = Vector2i(-1,-1)

# new_game resets the entire game to its starting state with a new snake in the starting
# position, a new apple, and no game-ticks.
func new_game():
	
	# Clear any old snake tiles that exist
	clear_game()
	
	# Set the snake and apple to their starting positions
	direction     = Vector2.RIGHT
	new_direction = Vector2.RIGHT
	snake_tiles = [
		SnakeTile.new(SnakeTile.Type.HEAD, Vector2i(10,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new(SnakeTile.Type.BODY, Vector2i(9,10),  Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new(SnakeTile.Type.BODY, Vector2i(8,10),  Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new(SnakeTile.Type.TAIL, Vector2i(7,10),  Vector2.RIGHT, Vector2.LEFT),
	]
	
	# Render the game pieces
	for s in snake_tiles:
		set_snake_cell(s)
	set_apple_cell()

# refresh_mode updates the TileSet atlas source ID according to whether or not WORM MODE
# is active.
func refresh_mode():
	
	# Set the TileSet atlas source ID
	if Global.worm_mode:
		source_id = 1
	else:
		source_id = 0
	
	# Refresh all the cells on all layers
	re_render_all_tiles()


## ----------- Child Node Behaviour Functions ---------- ##

# update_score updates the score in the HUD to be equal to the provided value.
func update_score(score:int):
	$HUD.update_score(score)

# update_high_score updates the high-score in the HUD to be equal to the provided value.
func update_high_score(high_score:int):
	$HUD.update_high_score(high_score)

# new_high_score temporarily renders the floating NEW HIGH SCORE popup text on top of the
# snake's head.
func new_high_score():
	$HUD/NewHighScore.temporarily_activate(get_head_tile_screen_pos())

# worm_mode_unlocked temporarily renders the floating WORM MODE UNLOCKED popup text on
# top of the snake's head.
func worm_mode_unlocked():
	$HUD/WormModeUnlocked.temporarily_activate(get_head_tile_screen_pos())


## ------------- Snake Movement Functions -------------- ##

# turn sets the snake to turn in the provided direction (if possible) on the next
# game-tick, returning true if so.
func turn(input_direction : Vector2) -> bool: 
	var turning:bool = direction.dot(input_direction) == 0
	if turning:
		new_direction = input_direction
	return turning

# move_snake moves the snake forward one cell, detecting if an apple, the wall, or the
# snake's own body has been colided with.
func move_snake(): 
	
	# Change the snake's direction if required
	if new_direction != direction:
		direction = new_direction
	
	# Build the new coordinates for the head tile
	var newHeadCoord = snake_tiles[0].get_coords() + Vector2i(direction)
	
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
		discolor_snake_tiles()
		dead.emit()

# move_head moves the snake's head forward one cell. If dead_head is true, the new snake 
# head is rendered as a dead head on the Foreground layer.
func move_head(newHeadCoord:Vector2i, dead_head:bool = false):
	
	# Change the old head tile to be a body tile facing the new direction
	var old_head:SnakeTile = snake_tiles[0]
	snake_tiles[0] = SnakeTile.new(
		SnakeTile.Type.BODY,
		old_head.get_coords(),
		direction, # The new head should face the new direction
		old_head.get_back_dir()
	)
	
	# Add the new head tile
	var newHeadTile : SnakeTile
	if !dead_head: 
		newHeadTile = SnakeTile.new(SnakeTile.Type.HEAD, newHeadCoord, direction, direction.rotated(PI))
	else: 
		newHeadTile = SnakeTile.new(SnakeTile.Type.DEAD_HEAD, newHeadCoord, direction, direction.rotated(PI))
	snake_tiles.push_front(newHeadTile)
	
	# Render the updated cells
	set_snake_cell(snake_tiles[0])
	set_snake_cell(snake_tiles[1])

# move_tail moves the snake's tail forward one tile.
func move_tail():
	
	# Change the new tail tile to be a tail tile facing the same direction
	var old_tail:SnakeTile = snake_tiles[-2] 
	snake_tiles[-2] = SnakeTile.new(
		SnakeTile.Type.TAIL, 
		old_tail.get_coords(), 
		old_tail.get_front_dir(), 
		old_tail.get_front_dir().rotated(PI) # The tail is always oriented in a straight line
	)
	
	# Remove the old tail tile
	var oldTailCoords = snake_tiles.pop_back().get_coords()
	
	# Render the updated cells
	set_snake_cell(snake_tiles[-1])
	layers[SnakeTile.Layer.SNAKE].erase_cell(oldTailCoords)


## --------------- Cell Setter Functions --------------- ##

# set_snake_cell places the provided SnakeTile on the game board according to its
# parameters.
func set_snake_cell(snake_tile : SnakeTile):
	layers[snake_tile.get_layer()].set_cell(snake_tile.get_coords(), source_id, snake_tile.get_atlas_coords(), snake_tile.get_alt_id())

# set_apple_cell erases any existing apple from the game board and places a new one
# randomly on the board on a non-snake tile.
func set_apple_cell():
	
	# Remove The old apple
	layers[SnakeTile.Layer.LEVEL].erase_cell(apple_coords)
	
	# TODO: This will potentially slow the game down in later stages of the game. Maybe think
	# of a more CPU-friendly implementation? 
	while true:
		apple_coords = Vector2i(randi_range(1,16), randi_range(2,17))
		if layers[SnakeTile.Layer.SNAKE].get_cell_tile_data(apple_coords) == null:
			break
	
	layers[SnakeTile.Layer.LEVEL].set_cell(apple_coords, source_id, SnakeTile.APPLE_ATLAS)

# re_render_all_tiles refreshes all tiles on all layers, including any updates to the
# source_id.
func re_render_all_tiles():
	for layer in layers:
		var layer_cell_coords = layer.get_used_cells()
		for cell_coords in layer_cell_coords:
			layer.set_cell(
				cell_coords, 
				source_id, 
				layer.get_cell_atlas_coords(cell_coords), 
				layer.get_cell_alternative_tile(cell_coords)
			)

# discolor_snake_tiles modulates the colour of the Snake tiles to gray.
func discolor_snake_tiles():
	layers[SnakeTile.Layer.SNAKE].modulate = Color.GRAY

## --------------- Cell Getter Functions --------------- ##

# cell_is_apple returns true if the cell at the provided coordinates has an apple on it.
func cell_is_apple(coords : Vector2i) -> bool:
	return coords == apple_coords

# cell_is_empty returns true if the cell at the provided coordinates is empty (does not
# check the Background or the Foreground layers).
func cell_is_empty(coords : Vector2i) -> bool:
	var level_layer_data = layers[SnakeTile.Layer.LEVEL].get_cell_tile_data(coords)
	var snake_layer_data = layers[SnakeTile.Layer.SNAKE].get_cell_tile_data(coords)
	return level_layer_data == null && snake_layer_data == null

# cell_is_tail returns true if the cell at the provided coordinates is the location of
# the snake's tail.
func cell_is_tail(coords : Vector2i) -> bool:
	return layers[SnakeTile.Layer.SNAKE].get_cell_atlas_coords(coords) == SnakeTile.TAIL_ATLAS

# get_head_tile_screen_pos returns the screen position coordinates of the center
# of the snake's head tile.
func get_head_tile_screen_pos() -> Vector2 :
	return Vector2(snake_tiles[0].get_coords()*layers[SnakeTile.Layer.BG].rendering_quadrant_size) + Vector2(0.5,0.5)*layers[SnakeTile.Layer.BG].rendering_quadrant_size
