extends Node

class_name SnakeTile

var coords       : Vector2i
var atlas_coords : Vector2i
var front_dir    : Vector2
var back_dir     : Vector2

# The atlas coordinates of each snake tile type
const HEAD_ATLAS     = Vector2i(3,0)
const STRAIGHT_ATLAS = Vector2i(4,0)
const CORNER_ATLAS   = Vector2i(5,0)
const TAIL_ATLAS     = Vector2i(5,1)

# Called when the node enters the scene tree for the first time.
func _init(type:String, coords:Vector2i, front_dir:Vector2, back_dir:Vector2):
	set_atlas_coords(type)
	self.coords = coords
	self.front_dir = front_dir
	self.back_dir = back_dir

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

func get_atlas_coords() -> Vector2i:
	return atlas_coords
	
func get_coords() -> Vector2i:
	return coords

func get_front_dir() -> Vector2:
	return front_dir

func get_back_dir() -> Vector2: 
	return back_dir
