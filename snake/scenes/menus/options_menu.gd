class_name OptionsMenu extends Control

signal mute
signal worm_mode
signal close

var unchecked_icon = preload("res://scenes/menus/components/checkBoxUnchecked.png")
var checked_icon = preload("res://scenes/menus/components/checkBoxChecked.png")

# show_and_focus shows the menu, and grabs the focus to the appropriate button.
func show_and_focus():
	$VBoxContainer/MuteContainer/MuteButton.update_icon(Global.mute)
	$VBoxContainer/WormModeContainer/WormModeButton.update_icon(Global.worm_mode)
	show()
	
	if SaveData.load().worm_mode_unlocked:
		$VBoxContainer/WormModeContainer/WormModeButton.disabled = false
		$HelpMessage.hide()
	else:
		$VBoxContainer/WormModeContainer/WormModeButton.disabled = true
		$HelpMessage.show()
	
	$VBoxContainer/MuteContainer/MuteButton.focus(true)


## ---------------- Button-Signal Funcs ---------------- ##

func _on_mute_button_pressed():
	mute.emit()
	$VBoxContainer/MuteContainer/MuteButton.update_icon(Global.mute)

func _on_worm_mode_button_pressed():
	worm_mode.emit()
	$VBoxContainer/WormModeContainer/WormModeButton.update_icon(Global.worm_mode)

func _on_close_button_pressed():
	close.emit()
