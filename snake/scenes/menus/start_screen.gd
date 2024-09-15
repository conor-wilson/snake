extends Control

var worm_title:Texture  = load("res://art/WormTitle.png")
var snake_title:Texture = load("res://art/Title.png") 

func show_and_focus():
	show()
	$PressAnyKey/Timer.start()

# update_mode (TODO)
# TODO: This is almost an exact copy of Snake.update_mode(). Fix this.
func update_mode():
	
	# Set the TileMap source ID
	var source_id : int
	if Global.worm_mode:
		source_id = 1
		$Title.texture = worm_title
	else:
		source_id = 0
		$Title.texture = snake_title
	
	# Refresh all the cells on all layers
	var layer_cell_coords = $TileMap.get_used_cells(0)
	for cell_coords in layer_cell_coords:
		$TileMap.set_cell(
			0, 
			cell_coords, 
			source_id, 
			$TileMap.get_cell_atlas_coords(0, cell_coords), 
			$TileMap.get_cell_alternative_tile(0, cell_coords)
			)
