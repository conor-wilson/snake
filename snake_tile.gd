extends Sprite2D

@export var coords : Vector2i
var front : Vector2
var back  : Vector2

# Constants for easily setting the texture region_rect
const TILE_WIDTH = 32
const HEAD_TEXTURE_REGION     = Rect2(TILE_WIDTH*3, TILE_WIDTH*0, TILE_WIDTH, TILE_WIDTH)
const STRAIGHT_TEXTURE_REGION = Rect2(TILE_WIDTH*4, TILE_WIDTH*0, TILE_WIDTH, TILE_WIDTH)
const CORNER_TEXTURE_REGION   = Rect2(TILE_WIDTH*5, TILE_WIDTH*0, TILE_WIDTH, TILE_WIDTH)
const TAIL_TEXTURE_REGION     = Rect2(TILE_WIDTH*5, TILE_WIDTH*1, TILE_WIDTH, TILE_WIDTH)


# Called when the node enters the scene tree for the first time.
func _init(type:String, coords:Vector2i, front_dir:Vector2, back_dir:Vector2):
	coords = coords
	region_rect = HEAD_TEXTURE_REGION
	rotate(PI)

func set_texture_from_type(type:String):
	match type:
		"head":
			region_rect = HEAD_TEXTURE_REGION
		"body":
			region_rect = STRAIGHT_TEXTURE_REGION # TODO: Add option for corner
		"tail":
			region_rect = TAIL_TEXTURE_REGION

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
