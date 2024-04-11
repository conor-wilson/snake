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

# TODO: Descriptor
func renderSnakeUpdate(oldTailCoords: Vector2i = Vector2i(-1,-1)):
	
	# Set new TileSet source settings for tiles to be updated
	snakeTiles[1].set_atlas_coords("body")
	snakeTiles[1].set_direction(direction, direction) # TODO: directions
	snakeTiles[snakeTiles.size()-1].set_atlas_coords("tail")
	
	# Update the tiles
	erase_cell(1, oldTailCoords)
	set_snake_cell(snakeTiles[0])
	set_snake_cell(snakeTiles[1])
	set_snake_cell(snakeTiles[snakeTiles.size()-1])


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
	
	# Build the new head SnakeTile 
	var newHeadTile = SnakeTile.new(
		"head", 
		snakeTiles[0].get_coords() + Vector2i(direction), 
		direction, 
		direction, # TODO: back_dir
	)
	
	# Move the snake according to what sort of tile it's about to run into:
	
	# Case where the snake eats the apple
	if get_cell_atlas_coords(1, newHeadTile.get_coords()) == Vector2i(2,1):
		snakeTiles.push_front(newHeadTile)
		renderSnakeUpdate()
		set_apple_cell()

	# Case where the snake hits nothing
	elif get_cell_tile_data(1, newHeadTile.get_coords()) == null:
		snakeTiles.push_front(newHeadTile) # TODO: Is this repeated code okay?
		renderSnakeUpdate(snakeTiles.pop_back().get_coords())

	# Case where the snake something that is not an apple
	else:
		# TODO: Make the snake die here.
		return


## --------------- Cell Setter Functions --------------- ##

# TODO: Descriptor
func set_snake_cell(snake_tile : SnakeTile):
	set_cell(1, snake_tile.get_coords(), 0, snake_tile.get_atlas_coords(), snake_tile.get_alt_id())

# TODO: Descriptor
func set_apple_cell(): 
	# TODO: make sure apple doesn't spawn on snake tile
	var coords = Vector2i(randi_range(2,17), randi_range(2,17))
	set_cell(1, coords, 0, Vector2(2,1))
