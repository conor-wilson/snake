extends Node

class_name SnakeTile

var coords       : Vector2i
var atlas_coords : Vector2i
var alt_id       : int

# The atlas coordinates of each snake tile type
const HEAD_ATLAS     = Vector2i(3,0)
const STRAIGHT_ATLAS = Vector2i(4,0)
const CORNER_ATLAS   = Vector2i(5,0)
const TAIL_ATLAS     = Vector2i(5,1)

# Called when the node enters the scene tree for the first time.
func _init(type:String, coords:Vector2i, front_dir:Vector2, back_dir:Vector2):
	set_atlas_coords(type)
	self.coords = coords
	set_alt_id(type, front_dir, back_dir)

# TODO: Discriptor
func set_atlas_coords(type:String):
	match type:
		"head":
			self.atlas_coords = HEAD_ATLAS
		"body":
			self.atlas_coords = STRAIGHT_ATLAS # TODO: Set the corner tile
		"tail":
			self.atlas_coords = TAIL_ATLAS
		_:
			print_debug("unknown snake tile type string", type)

# TODO: Descriptor
func set_alt_id(type:String, front_dir:Vector2, back_dir:Vector2):
	self.alt_id = cardinal_to_alt_id(front_dir)
	if type == "body":
		self.alt_id = (alt_id-1)%2+1

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
	if direction.angle() == (Vector2.UP + Vector2.RIGHT).angle(): 
		altID = 1
	elif direction.angle() == (Vector2.RIGHT + Vector2.DOWN).angle():
		altID = 2
	elif direction.angle() == (Vector2.DOWN + Vector2.LEFT).angle():
		altID = 3
	elif direction.angle() == (Vector2.LEFT + Vector2.UP).angle():
		altID = 4
	else:
		print_debug("invalid direction input to cardinal_to_corner_alt_id():", direction)
	
	return altID

func get_atlas_coords() -> Vector2i:
	return atlas_coords
	
func get_coords() -> Vector2i:
	return coords

func get_alt_id() -> int:
	return alt_id
