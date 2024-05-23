class_name OptionsMenu extends Control

signal mute
signal worm_mode
signal close

func show_and_focus(worm_mode_unlocked:bool):
	
	show()
	if worm_mode_unlocked:
		$HelpMessage.show()
	else: 
		$HelpMessage.hide()
	
	$VBoxContainer/MuteContainer/MuteButton.grab_focus()

func set_mute_icon(checked:bool):
	$VBoxContainer/MuteContainer/MuteButton.set_icon(checked)

func set_worm_mode_icon(checked:bool):
	$VBoxContainer/WormModeContainer/WormModeButton.set_icon(checked)


func _on_mute_button_pressed():
	mute.emit()

func _on_worm_mode_button_pressed():
	worm_mode.emit()

func _on_close_button_pressed():
	close.emit()
