extends Control

var worm_title:Texture  = load("res://scenes/menus/WormTitle.png")
var snake_title:Texture = load("res://scenes/menus/Title.png") 

func show_and_focus():
	show()

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
	var layer_cell_coords = $TileMapLayer.get_used_cells()
	for cell_coords in layer_cell_coords:
		$TileMapLayer.set_cell(
			cell_coords, 
			source_id, 
			$TileMapLayer.get_cell_atlas_coords(cell_coords), 
			$TileMapLayer.get_cell_alternative_tile(cell_coords)
			)
