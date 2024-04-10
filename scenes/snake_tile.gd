extends Node

class_name SnakeTile

var type       : String
var coords     : Vector2i
var front_dir  : Vector2
var back_dir   : Vector2

# Called when the node enters the scene tree for the first time.
func _init(type:String, coords:Vector2i, front_dir:Vector2, back_dir:Vector2):
	self.type = type
	self.coords = coords
	self.front_dir = front_dir
	self.back_dir = back_dir
	
func get_type() -> String:
	return type
	
func get_coords() -> Vector2i:
	return coords

func get_front_dir() -> Vector2:
	return front_dir

func get_back_dir() -> Vector2: 
	return back_dir
