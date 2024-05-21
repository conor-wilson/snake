class_name OptionsMenu extends Control

signal mute
signal worm_mode
signal close


func toggle_visibility():
	if !is_visible_in_tree():
		show()
	else:
		hide()

func focus():
	$VBoxContainer/MuteButton.grab_focus()

func _on_mute_button_pressed():
	mute.emit()

func _on_worm_mode_button_pressed():
	worm_mode.emit()

func _on_close_button_pressed():
	close.emit()
