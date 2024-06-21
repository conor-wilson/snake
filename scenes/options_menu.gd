class_name OptionsMenu extends Control

signal mute
signal worm_mode
signal close

var unchecked_icon = preload("res://art/checkBoxUnchecked.png")
var checked_icon = preload("res://art/checkBoxChecked.png")

func show_and_focus(worm_mode_unlocked:bool):
	$VBoxContainer/MuteContainer/MuteButton.update_icon(Global.mute)
	$VBoxContainer/WormModeContainer/WormModeButton.update_icon(Global.worm_mode)
	show()
	if worm_mode_unlocked:
		$HelpMessage.hide()
	else:
		$HelpMessage.show()
	
	$VBoxContainer/MuteContainer/MuteButton.focus(true)

func _on_mute_button_pressed():
	mute.emit()
	$VBoxContainer/MuteContainer/MuteButton.update_icon(Global.mute)

func _on_worm_mode_button_pressed():
	worm_mode.emit()
	$VBoxContainer/WormModeContainer/WormModeButton.update_icon(Global.worm_mode)

func _on_close_button_pressed():
	close.emit()
