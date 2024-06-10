class_name OptionsMenu extends Control

signal mute
signal worm_mode
signal close

var unchecked_icon = preload("res://art/checkBoxUnchecked.png")
var checked_icon = preload("res://art/checkBoxChecked.png")

func show_and_focus(worm_mode_unlocked:bool):
	refresh_mute_icon()
	show()
	if worm_mode_unlocked:
		$HelpMessage.hide()
	else:
		$HelpMessage.show()
	
	$VBoxContainer/MuteContainer/MuteButton.focus(true)

func refresh_mute_icon():
	$VBoxContainer/MuteContainer/MuteButton.icon = get_checkbox_icon(Global.mute)

func set_worm_mode_icon(checked:bool):
	# TODO: Move this functionality over to menu_button.gd (or at least de-duplicate this)?
	if checked:
		$VBoxContainer/WormModeContainer/WormModeButton.icon = checked_icon
	else:
		$VBoxContainer/WormModeContainer/WormModeButton.icon = unchecked_icon

# TODO: Move this functionality over to menu_button.gd?
func get_checkbox_icon(checked:bool) -> Resource:
	if checked:
		return checked_icon
	else:
		return unchecked_icon

func _on_mute_button_pressed():
	mute.emit()
	refresh_mute_icon()

func _on_worm_mode_button_pressed():
	worm_mode.emit()

func _on_close_button_pressed():
	close.emit()
