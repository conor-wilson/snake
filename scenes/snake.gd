extends TileMap


var snakeTiles : Array   # The array of coordinates that the snake occupies
var direction  : Vector2 # The cardinal direction of the snake's head

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Set the snake and apple to their starting positions
	direction = Vector2.RIGHT
	snakeTiles = [Vector2i(11, 10), Vector2i(10, 10), Vector2i(9, 10)]
	renderNewSnake()
	set_apple_cell()


## ------------- Snake Rendering Functions ------------- ##

# TODO: Descriptor
# TODO: Change the direction vectors to not always be Vector2.RIGHT
func renderNewSnake():
	
	# Render head
	set_head_cell(snakeTiles[0], Vector2.RIGHT)
	
	# Render body
	var len = snakeTiles.size()
	for i in range(len-2):
		set_body_cell(snakeTiles[i+1], Vector2.LEFT, Vector2.RIGHT)
	
	# Render tail
	set_tail_cell(snakeTiles[len-1], Vector2.RIGHT)

# TODO: Descriptor
# TODO: Change the direction vectors to not always be Vector2.RIGHT
func renderSnakeUpdate(oldTailCoords: Vector2i = Vector2i(-1,-1)):
	erase_cell(1, oldTailCoords)
	set_head_cell(snakeTiles[0], direction)
	set_body_cell(snakeTiles[1], Vector2.LEFT, Vector2.RIGHT)
	set_tail_cell(snakeTiles[snakeTiles.size()-1], Vector2.RIGHT)


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
	
	# Obtain the next location for the snake's head
	var newHeadCoords = snakeTiles[0] + Vector2i(direction)
	
	# Move the snake according to what sort of tile it's about to run into:
	
	# Case where the snake eats the apple
	if get_cell_atlas_coords(1, newHeadCoords) == Vector2i(2,1):
		snakeTiles.push_front(newHeadCoords)
		renderSnakeUpdate()
		set_apple_cell()

	# Case where the snake something other than the apple
	elif get_cell_tile_data(1, newHeadCoords) != null:
		# TODO: Make the snake die here.
		return

	# Case where the snake hits nothing
	else:
		snakeTiles.push_front(newHeadCoords) # TODO: Is this repeated code okay?
		renderSnakeUpdate(snakeTiles.pop_back())


## --------------- Cell Setter Functions --------------- ##

# TODO: Descriptor
func set_head_cell(coords: Vector2i, direction: Vector2):
	var altID = cardinal_to_alt_id(direction)
	set_cell(1, coords, 0, Vector2(3,0), altID)

# TODO: Descriptor
func set_body_cell(coords: Vector2i, dir1: Vector2, dir2: Vector2): 
	var vSum = dir1+dir2
	
	if vSum.length() == 0:
		# The direction vectors are exactly opposite. This must be a straight body tile. 
		var altID = cardinal_to_alt_id(dir1)
		set_cell(1, coords, 0, Vector2(4,0), (altID-1)%2+1)
	else:
		# The direction vectors are not opposite. This must be a corner body tile.
		var altID = cardinal_to_corner_alt_id(vSum)
		set_cell(1, coords, 0, Vector2(5,0), altID)

# TODO: Descriptor
func set_tail_cell(coords: Vector2i, direction: Vector2):
	var altID = cardinal_to_alt_id(direction)
	set_cell(1, coords, 0, Vector2(5,1), altID)

# TODO: Descriptor
func set_apple_cell(): 
	# TODO: make sure apple doesn't spawn on snake tile
	var coords = Vector2i(randi_range(2,17), randi_range(2,17))
	set_cell(1, coords, 0, Vector2(2,1))

# TODO: Descriptor
func cardinal_to_alt_id(direction: Vector2) -> int:

	var altID = 0
	if direction.angle() == Vector2.UP.angle():
		altID = 1
	elif direction.angle() == Vector2.RIGHT.angle():
		altID = 2
	elif direction.angle() == Vector2.DOWN.angle():
		altID = 3
	elif direction.angle() == Vector2.LEFT.angle():
		altID = 4
	else: 
		print_debug("invalid direction input to cardinal_to_alt_id():", direction)

	return altID

# TODO: Descriptor
func cardinal_to_corner_alt_id(direction: Vector2) -> int:

	var altID = 0
	if direction == Vector2.UP + Vector2.RIGHT: 
		altID = 1
	elif direction == Vector2.RIGHT + Vector2.DOWN:
		altID = 2
	elif direction == Vector2.DOWN + Vector2.LEFT:
		altID = 3
	elif direction == Vector2.LEFT + Vector2.UP:
		altID = 4
	else:
		print_debug("invalid direction input to cardinal_to_corner_alt_id():", direction)
	
	return altID
