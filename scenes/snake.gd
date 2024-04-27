extends TileMap

signal hit

var play : bool

var snakeTiles    : Array[SnakeTile] # The array of the snake's tiles
var appleCoords   : Vector2i         # The coordinate of the apple tile
var direction     : Vector2          # The direction of the snake's head
var new_direction : Vector2          # The new direction for the snake's head


## ---------- High-Level Behaviour Functions ----------- ##

# Called when the node enters the scene tree for the first time.
func _ready():
	play        = false
	snakeTiles  = []
	appleCoords = Vector2i(-1, -1)

# TODO: descriptor
func spawn_new_snake():

	# Remove the old snake if it exists
	clear_snake_and_apple()
	play = true
	
	# Set the snake and apple to their starting positions
	direction     = Vector2.RIGHT
	new_direction = Vector2.RIGHT
	snakeTiles = [
		SnakeTile.new("head", Vector2i(11,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("body", Vector2i(10,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("tail", Vector2i(9,10),  Vector2.RIGHT, Vector2.LEFT),
	]
	renderNewSnake()
	set_apple_cell()

# TODO: descriptor
func pause(): 
	play = false

# TODO: descriptor
func kill_snake(): 
	play = false


## ------------- Snake Rendering Functions ------------- ##

# TODO: Descriptor
func renderNewSnake():
	for s in snakeTiles:
		set_snake_cell(s)


## ------------- Snake Movement Functions -------------- ##

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_player_input()

# TODO: Descriptor
# TODO: This actually feels a little bit weird here. Might need to move this to a
# different node exclusively for handling player inputs
func process_player_input():
	
	# Player inputs during gameplay
	if play: 
		if Input.is_action_pressed("move_up") && direction != Vector2.DOWN:
			new_direction = Vector2.UP
		if Input.is_action_pressed("move_right") && direction != Vector2.LEFT:
			new_direction = Vector2.RIGHT
		if Input.is_action_pressed("move_down") && direction != Vector2.UP:
			new_direction = Vector2.DOWN
		if Input.is_action_pressed("move_left") && direction != Vector2.RIGHT:
			new_direction = Vector2.LEFT

# TODO: Descriptor
# TODO: Maybe this should be moved to the main scene...
func _on_ticker_timeout():
	if play:
		direction = new_direction
		moveSnake()

# TODO: Descriptor
func moveSnake(): 
	
	# Build the new coordinates for the head tile
	var newHeadCoord = snakeTiles[0].get_coords() + Vector2i(direction)
	
	# Move the snake according to what sort of tile it's about to run into:
	
	# Case where the snake eats the apple
	if get_cell_atlas_coords(1, newHeadCoord) == Vector2i(2,1):
		move_head(newHeadCoord)
		set_apple_cell()

	# Case where the snake hits nothing
	elif get_cell_tile_data(1, newHeadCoord) == null:
		move_head(newHeadCoord)
		move_tail()

	# Case where the snake something that is not an apple
	else:
		hit.emit()
		return

# TODO: descriptor
func move_head(newHeadCoord : Vector2i):
	
	# Change the old head tile to be a body tile facing the new direction
	snakeTiles[0].set_atlas_coords("body")
	snakeTiles[0].set_direction(direction, snakeTiles[0].get_back_dir())
	
	# Add the new head tile
	var newHeadTile = SnakeTile.new("head", newHeadCoord, direction, direction.rotated(PI))
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
# TODO: Think about using pop() funcs here. Might be more efficient?
func clear_snake_and_apple():
	
	# Clear the snake tiles
	for s in snakeTiles:
		erase_cell(1, s.coords)
	snakeTiles = []
	
	# Clear the apple tile
	erase_cell(1, appleCoords)
	appleCoords = Vector2i(-1,-1)

## --------------- Cell Setter Functions --------------- ##

# TODO: Descriptor
func set_snake_cell(snake_tile : SnakeTile):
	set_cell(1, snake_tile.get_coords(), 0, snake_tile.get_atlas_coords(), snake_tile.get_alt_id())

# TODO: Descriptor
func set_apple_cell(): 
	
	# TODO: This will potentially slow the game down in later stages of the game. Maybe think
	# of a more CPU-friendly implementation? 
	while true:
		appleCoords = Vector2i(randi_range(2,17), randi_range(2,17))
		if get_cell_tile_data(1, appleCoords) == null:
			break
	
	set_cell(1, appleCoords, 0, Vector2(2,1))
 
