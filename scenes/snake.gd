extends TileMap

# TODO:
#var snakeTiles : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var snakeTiles : Array = [Vector2i(11, 10), Vector2i(10, 10), Vector2(9, 10)]
	renderNewSnake(snakeTiles)
	
	set_apple_cell()


func renderNewSnake(snakeTiles: Array):
	
	set_head_cell(snakeTiles[0], Vector2.RIGHT)
	
	var len = snakeTiles.size()
	for i in range(len-2):
		set_body_cell(snakeTiles[i+1], Vector2.RIGHT, Vector2.UP)
	
	set_tail_cell(snakeTiles[len-1], Vector2.RIGHT)

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
	 
#
## TODO: Descriptor
#func set_straight_cell(coords: Vector2i, direction: Vector2):
	#var altID = cardinal_to_alt_id(direction)
	#set_cell(1, coords, 0, Vector2(4,0), (altID-1)%2+1)
#
#
## TODO: Descriptor
#func set_corner_cell(coords: Vector2i, dir1: Vector2, dir2: Vector2):
	#var altID = cardinal_to_corner_alt_id(dir1+dir2)
	#set_cell(1, coords, 0, Vector2(5,0), altID)


# TODO: Descriptor
func set_tail_cell(coords: Vector2i, direction: Vector2):
	var altID = cardinal_to_alt_id(direction)
	set_cell(1, coords, 0, Vector2(5,1), altID)


# TODO: Descriptor
func set_apple_cell(): 
	# TODO: make sure apple doesn't spawn on snake tile
	var coords = Vector2i(randi_range(2,18), randi_range(2,18))
	set_cell(1, coords, 0, Vector2(2,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# TODO: Descriptor
func cardinal_to_alt_id(direction: Vector2) -> int:

	var altID = 0
	if direction == Vector2.UP:
		altID = 1
	elif direction == Vector2.RIGHT:
		altID = 2
	elif direction == Vector2.DOWN:
		altID = 3
	elif direction == Vector2.LEFT:
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
	
