class_name OptionsMenu extends Control

signal mute
signal worm_mode
signal close

var unchecked_icon = preload("res://art/checkBoxUnchecked.png")
var checked_icon = preload("res://art/checkBoxChecked.png")

func show_and_focus(worm_mode_unlocked:bool):
	
	show()
	if worm_mode_unlocked:
		$HelpMessage.hide()
	else:
		$HelpMessage.show()
	
	$VBoxContainer/MuteContainer/MuteButton.focus(true)

func set_mute_icon(checked:bool):
	# TODO: Move this functionality over to menu_button.gd?
	if checked:
		$VBoxContainer/MuteContainer/MuteButton.icon = checked_icon
	else:
		$VBoxContainer/MuteContainer/MuteButton.icon = unchecked_icon

func set_worm_mode_icon(checked:bool):
	# TODO: Move this functionality over to menu_button.gd (or at least de-duplicate this)?
	if checked:
		$VBoxContainer/MuteContainer/WormModeButton.icon = checked_icon
	else:
		$VBoxContainer/MuteContainer/WormModeButton.icon = unchecked_icon


func _on_mute_button_pressed():
	mute.emit()

func _on_worm_mode_button_pressed():
	worm_mode.emit()

func _on_close_button_pressed():
	close.emit()
