class_name SnakeTile extends Node

# TODO: This feels like it should be a globally available enum (if that's possible)
enum Layer { BG, LEVEL, SNAKE, FG }

var coords       : Vector2i
var front_dir    : Vector2
var back_dir     : Vector2
var layer        : Layer
var atlas_coords : Vector2i
var alt_id       : int


# The atlas coordinates of each snake tile type
# TODO: This actually also feels like it should be globally available...
const HEAD_ATLAS      = Vector2i(3,0)
const STRAIGHT_ATLAS  = Vector2i(4,0)
const CORNER_ATLAS    = Vector2i(5,0)
const TAIL_ATLAS      = Vector2i(5,1)
const DEAD_HEAD_ATLAS = Vector2i(3,1)
const APPLE_ATLAS     = Vector2i(2,1)

# Called when the node enters the scene tree for the first time.
func _init(type:String, coords:Vector2i, front_dir:Vector2, back_dir:Vector2):
	
	var dir_sum = front_dir + back_dir
	
	self.coords = coords
	set_layer(type)
	set_atlas_coords(type)
	set_direction(front_dir, back_dir)

# TODO: Descriptor
func set_layer(type:String):
	if type == "dead_head":
		self.layer = Layer.FG
	else:
		self.layer = Layer.SNAKE

# TODO: Descriptor
func set_atlas_coords(type:String):
	match type:
		"head":
			self.atlas_coords = HEAD_ATLAS
		"dead_head":
			self.atlas_coords = DEAD_HEAD_ATLAS
		"body":
			self.atlas_coords = STRAIGHT_ATLAS # TODO: Set the corner tile
		"tail":
			self.atlas_coords = TAIL_ATLAS
		_:
			print_debug("unknown snake tile type string", type)

# TODO: Descriptor
func set_direction(front_dir:Vector2, back_dir:Vector2):
	self.front_dir = front_dir
	self.back_dir  = back_dir
	
	var dir_sum = front_dir+back_dir 
	if dir_sum.length() > 1:
		self.atlas_coords = CORNER_ATLAS # TODO: This is janky!
		self.alt_id = direction_to_corner_alt_id(dir_sum)
	else: 
		self.alt_id = direction_to_alt_id(front_dir)

# TODO: Descriptor
func direction_to_alt_id(direction: Vector2) -> int:

	var altID = 0
	if direction.is_equal_approx(Vector2.UP):
		altID = 1
	elif direction.is_equal_approx(Vector2.RIGHT):
		altID = 2
	elif direction.is_equal_approx(Vector2.DOWN):
		altID = 3
	elif direction.is_equal_approx(Vector2.LEFT):
		altID = 4
	else: 
		print_debug("invalid direction input to direction_to_corner_alt_id():", direction)

	return altID

# TODO: Descriptor
func direction_to_corner_alt_id(direction: Vector2) -> int:

	var altID = 0
	if direction.is_equal_approx(Vector2.UP + Vector2.RIGHT): 
		altID = 1
	elif direction.is_equal_approx(Vector2.RIGHT + Vector2.DOWN):
		altID = 2
	elif direction.is_equal_approx(Vector2.DOWN + Vector2.LEFT):
		altID = 3
	elif direction.is_equal_approx(Vector2.LEFT + Vector2.UP):
		altID = 4
	else:
		print_debug("invalid direction input to direction_to_corner_alt_id():", direction)
	
	return altID

# TODO: Reorder these, and maybe have them defined within the field definition?

func get_atlas_coords() -> Vector2i:
	return atlas_coords
	
func get_coords() -> Vector2i:
	return coords

func get_alt_id() -> int:
	return alt_id

func get_front_dir() -> Vector2:
	return front_dir

func get_back_dir() -> Vector2:
	return back_dir

func get_layer() -> Layer:
	return layer
