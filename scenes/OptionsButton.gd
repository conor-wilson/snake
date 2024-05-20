extends Button

signal mute
signal worm_mode

var popupMenu:PopupMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	popupMenu = $OptionsMenu.get_popup()
	popupMenu.id_pressed.connect(_on_options_menu_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$OptionsMenu.show_popup()


func _on_options_menu_button_pressed(id : int):
	
	if popupMenu.is_item_checkable(id):
		popupMenu.toggle_item_checked(id)
	
	match id: 
		0: 
			mute.emit()
			$OptionsMenu.show_popup()
			print("MUTE!")
		1: 
			worm_mode.emit()
			$OptionsMenu.show_popup()
			print("WORM MODE!")
