class_name ControlsMenu extends Control

signal close

func show_and_focus():
	show()
	$VBoxContainer/CloseContainer/CloseButton.focus(true)

func _on_close_button_pressed():
	close.emit()
