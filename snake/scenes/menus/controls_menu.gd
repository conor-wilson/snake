class_name ControlsMenu extends Control

signal close

# show_and_focus shows the menu, and grabs the focus to the appropriate button.
func show_and_focus():
	show()
	$VBoxContainer/CloseContainer/CloseButton.focus(true)


## ---------------- Button-Signal Funcs ---------------- ##

func _on_close_button_pressed():
	close.emit()
