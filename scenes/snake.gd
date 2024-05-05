extends TileMap

signal turn
signal hit # TODO: rename this to "dead"?
signal apple_eaten

var snakeTiles    : Array[SnakeTile] # The array of the snake's tiles
var appleCoords   : Vector2i         # The coordinate of the apple tile
var direction     : Vector2          # The direction of the snake's head
var new_direction : Vector2          # The new direction for the snake's head


## ---------- High-Level Behaviour Functions ----------- ##

# Called when the node enters the scene tree for the first time.
func _ready():
	stop_ticker()
	snakeTiles  = []
	appleCoords = Vector2i(-1, -1)

# TODO: descriptor
func spawn_new_snake():
	
	# Clear any old snake tiles that exist
	clear_snake_and_apple()
	
	# Set the snake and apple to their starting positions
	direction     = Vector2.RIGHT
	new_direction = Vector2.RIGHT
	snakeTiles = [
		SnakeTile.new("head", Vector2i(11,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("body", Vector2i(10,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("body", Vector2i(9,10),  Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("tail", Vector2i(8,10),  Vector2.RIGHT, Vector2.LEFT),
	]
	renderNewSnake()
	set_apple_cell()

# TODO: descriptor
func start_ticker():
	# TODO: This feels extremely inefficient. Find a way to wait for the first
	# player input that doesn't involve a conditional checked with every single
	# player input
	if $Ticker.is_stopped():
		$Ticker.start()

# TODO: descriptor
func stop_ticker():
	if !$Ticker.is_stopped():
		$Ticker.stop()


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
		# TODO: Given the existance of this signal, it REALLY feels like this func should be in main...
		turn.emit()
		direction = new_direction
	
	moveSnake()

# TODO: Descriptor
func moveSnake(): 
	
	# Build the new coordinates for the head tile
	var newHeadCoord = snakeTiles[0].get_coords() + Vector2i(direction)
	
	# Move the snake according to what sort of tile it's about to run into:
	var next_cell_atlas_coords =  get_cell_atlas_coords(1, newHeadCoord)
	
	# Case where the snake eats the apple
	if next_cell_atlas_coords == SnakeTile.APPLE_ATLAS:
		move_head(newHeadCoord)
		set_apple_cell()
		apple_eaten.emit()
	
	# Case where the snake hits nothing
	elif get_cell_tile_data(1, newHeadCoord) == null || next_cell_atlas_coords == SnakeTile.TAIL_ATLAS:
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
	erase_cell(1, oldTailCoords)

# TODO: Descriptor
func clear_snake_and_apple():
	
	# Clear the snake tiles
	for s in snakeTiles:
		erase_cell(s.get_layer(), s.get_coords())
	snakeTiles = []
	
	# Clear the apple tile
	erase_cell(1, appleCoords)
	appleCoords = Vector2i(-1,-1)


## --------------- Cell Setter Functions --------------- ##

# TODO: Descriptor
func set_snake_cell(snake_tile : SnakeTile):
	set_cell(snake_tile.get_layer(), snake_tile.get_coords(), 0, snake_tile.get_atlas_coords(), snake_tile.get_alt_id())

# TODO: Descriptor
func set_apple_cell(): 
	
	# TODO: This will potentially slow the game down in later stages of the game. Maybe think
	# of a more CPU-friendly implementation? 
	while true:
		appleCoords = Vector2i(randi_range(2,17), randi_range(2,17))
		if get_cell_tile_data(1, appleCoords) == null:
			break
	
	set_cell(1, appleCoords, 0, Vector2(2,1))

