extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	set_head_cell(Vector2(11, 10), Vector2.RIGHT)
	set_cell(1, Vector2(10, 10), 0, Vector2(4,0), 2)
	set_cell(1, Vector2(9,  10), 0, Vector2(5,1), 2)


func set_head_cell(coords: Vector2i, direction: Vector2):
	
	# Obtain the alternativeTileID from the priovided direction var
	var alternateID = 0
	if direction == Vector2.UP:
		alternateID = 1
	elif direction == Vector2.RIGHT:
		alternateID = 2
	elif direction == Vector2.DOWN:
		alternateID = 3
	elif direction == Vector2.LEFT:
		alternateID = 4
	else: 
		print("invalid direction input to set_head_cell():", direction)
		return
	
	# Set the appropriate cell to the head tile
	set_cell(1, coords, 0, Vector2(3,0), alternateID)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
