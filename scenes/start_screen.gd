extends Control

func show_and_focus():
	show()
	$PressAnyKey/Timer.start()

func update_mode():
	
	# Set the TileMap source ID
	var source_id : int
	if Global.worm_mode:
		source_id = 1
	else:
		source_id = 0
	
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
