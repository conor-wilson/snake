extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	set_head_cell(Vector2(11, 10), Vector2.UP)
	set_cell(1, Vector2(10, 10), 0, Vector2(4,0), 2)
	set_cell(1, Vector2(9,  10), 0, Vector2(5,1), 2)


# TODO: Descriptor
func set_head_cell(coords: Vector2i, direction: Vector2):
	
	# Obtain the alternativeTileID from the priovided direction var
	var altID = cardinal_to_alt_id(direction)
	
	# Set the appropriate cell to the head tile
	set_cell(1, coords, 0, Vector2(3,0), altID)


#func set_tail_cell(coords: Vector2i, direction: Vector2):


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
		print_debug("invalid direction input to set_head_cell():", direction)

	return altID
