class_name SnakeTile extends Node

## The SnakeTile class represents one of the tiles in the tilemap that the snake is
## occupying. It contains all the information required to render the tile correctly in
## the appropriate TileMapLayer.
##
## NOTE: This methodology was initially concieved in Godot 4.2, and thus was designed
##       with the old TileMap Node type in mind. It still works well enough with the
##       TileMapLayer Node type, but there might have been a more appropriate way to go
##       about representing a snake tile if the project was built with TileMapLayers in
##       the first place.

# Type indicates which of the snake's body parts this SnakeTile represents.
#
# NOTE: Although there are no variables within this class that explicitely make use of
#       this enum, it is used throughout the class's logic and is required in its
#       constructor.
enum Type { HEAD, DEAD_HEAD, BODY, TAIL }

# Layer represents the TileMapLayer on which the SnakeTile shoud be rendered.
enum Layer { BG, LEVEL, SNAKE, FG }
var layer : Layer

var coords       : Vector2i # The coordinates of the SnakeTile on the game board
var front_dir    : Vector2  # The direction that the front of the SnakeTile is facing.
var back_dir     : Vector2  # The direction that the back of the SnakeTile is facing.
var atlas_coords : Vector2i # The atlas coordinates of the SnakeTile.
var alt_id       : int      # The alt ID of the SnakeTile in the atlas (used to rotate the tile correctly)

# The atlas coordinates of each SnakeTile type
const HEAD_ATLAS      = Vector2i(3,0)
const STRAIGHT_ATLAS  = Vector2i(4,0)
const CORNER_ATLAS    = Vector2i(5,1)
const TAIL_ATLAS      = Vector2i(5,0)
const DEAD_HEAD_ATLAS = Vector2i(4,1)
const APPLE_ATLAS     = Vector2i(3,1)

## -------------------- Constructor -------------------- ##
func _init(type:Type, coords:Vector2i, front_dir:Vector2, back_dir:Vector2):
	
	# Set the basic variables
	self.coords = coords
	self.front_dir = front_dir
	self.back_dir  = back_dir
	
	# Derrive the more complex variables
	set_layer(type)
	set_atlas_coords(type)
	set_alt_id()

# set_layer sets the layer of the SnakeTile. If is_dead is true, the tile 
func set_layer(type:Type):
	if type == Type.DEAD_HEAD:
		self.layer = Layer.FG
	else:
		self.layer = Layer.SNAKE

# set_atlas_coords sets the atlas coordinates of the SnakeTile according to the provided Type.
func set_atlas_coords(type:Type):
	match type:
		Type.HEAD:
			self.atlas_coords = HEAD_ATLAS
		Type.DEAD_HEAD:
			self.atlas_coords = DEAD_HEAD_ATLAS
		Type.BODY:
			if self.is_corner_tile():
				self.atlas_coords = CORNER_ATLAS
			else:
				self.atlas_coords = STRAIGHT_ATLAS
		Type.TAIL:
			self.atlas_coords = TAIL_ATLAS
		_:
			print_debug("unknown snake tile type ", type)

# set_alt_id sets the alt ID within the atlas for the SnakeTile. This effectively rotates
# the SnakeTile to be oriented in the correct way. It is assumed that when this function
# is called, the front_dir and back_dir variables have already been set.
func set_alt_id():
	var direction = front_dir
	if self.is_corner_tile():
		self.alt_id = direction_to_corner_alt_id(front_dir+back_dir)
	else:
		self.alt_id = direction_to_alt_id(front_dir)

# direction_to_alt_id returns the alt ID that corresponds to the provided front
# direction. 
#
# This function does NOT apply to corner tiles (see derection_to_corner_alt_id()).
func direction_to_alt_id(front_dir:Vector2) -> int:

	var altID:int = 0
	if front_dir.is_equal_approx(Vector2.UP):
		altID = 1
	elif front_dir.is_equal_approx(Vector2.RIGHT):
		altID = 2
	elif front_dir.is_equal_approx(Vector2.DOWN):
		altID = 3
	elif front_dir.is_equal_approx(Vector2.LEFT):
		altID = 4
	else: 
		print_debug("invalid direction input to direction_to_corner_alt_id():", front_dir)

	return altID

# direction_to_corner_alt_id returns the alt ID that corresponds to a corner tile with
# the provided sum of front and back directions.
#
# NOTE: I am certain that there is some more clever, mathematically satisfying method of
#       handling this functionality (eg: transforming the vectors in some way that
#       negates the need for both this function and direction_to_alt_id(). HOWEVER,
#       having experimented with that a bit, all that really did was make the code
#       much harder to read, so it is of my opinion that ultimately, this is actually
#       a pretty decent (or at the very least, clear) way of handling this.
func direction_to_corner_alt_id(dir_sum:Vector2) -> int:

	var altID = 0
	if dir_sum.is_equal_approx(Vector2.UP + Vector2.RIGHT): 
		altID = 1
	elif dir_sum.is_equal_approx(Vector2.RIGHT + Vector2.DOWN):
		altID = 2
	elif dir_sum.is_equal_approx(Vector2.DOWN + Vector2.LEFT):
		altID = 3
	elif dir_sum.is_equal_approx(Vector2.LEFT + Vector2.UP):
		altID = 4
	else:
		print_debug("invalid direction input to direction_to_corner_alt_id():", dir_sum)
	
	return altID

# is_corner_tile returns true if the SnakeTile is a corner tile.
func is_corner_tile() -> bool:
	return (front_dir+back_dir).length() > 1


## ---------------------- Getters ---------------------- ##

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
