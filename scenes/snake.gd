extends TileMap

var snakeTiles : Array[SnakeTile] # The array of coordinates that the snake occupies
var direction  : Vector2          # The cardinal direction of the snake's head

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Set the snake and apple to their starting positions
	direction = Vector2.RIGHT
	snakeTiles = [
		SnakeTile.new("head", Vector2i(11,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("body", Vector2i(10,10), Vector2.RIGHT, Vector2.LEFT),
		SnakeTile.new("tail", Vector2i(9,10),  Vector2.RIGHT, Vector2.LEFT),
	]
	renderNewSnake()
	set_apple_cell()


## ------------- Snake Rendering Functions ------------- ##

# TODO: Descriptor
func renderNewSnake():
	for s in snakeTiles:
		set_snake_cell(s)


## ------------- Snake Movement Functions -------------- ##

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_direction_from_input()

# TODO: Descriptor
func update_direction_from_input():
	# TODO: Fix bug where the player can go 180 degrees by quickly pressing 2 buttons.
	if Input.is_action_pressed("move_up") && direction != Vector2.DOWN:
		direction = Vector2.UP
	if Input.is_action_pressed("move_right") && direction != Vector2.LEFT:
		direction = Vector2.RIGHT
	if Input.is_action_pressed("move_down") && direction != Vector2.UP:
		direction = Vector2.DOWN
	if Input.is_action_pressed("move_left") && direction != Vector2.RIGHT:
		direction = Vector2.LEFT

# TODO: Descriptor
func _on_ticker_timeout():
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
		# TODO: Make the snake die here.
		return

# TODO: descriptor
func move_head(newHeadCoord : Vector2i):
	
	# Change the old head tile to be a body tile facing the new direction
	snakeTiles[0].set_atlas_coords("body")
	snakeTiles[0].set_direction(direction, snakeTiles[1].get_back_dir())
	
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


## --------------- Cell Setter Functions --------------- ##

# TODO: Descriptor
func set_snake_cell(snake_tile : SnakeTile):
	set_cell(1, snake_tile.get_coords(), 0, snake_tile.get_atlas_coords(), snake_tile.get_alt_id())

# TODO: Descriptor
func set_apple_cell(): 
	# TODO: make sure apple doesn't spawn on snake tile
	var coords = Vector2i(randi_range(2,17), randi_range(2,17))
	set_cell(1, coords, 0, Vector2(2,1))
