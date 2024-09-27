extends Control

signal start_game
signal mute
signal worm_mode
signal quit

func show_and_focus(high_score:int):
	$HighScore.text = "High Score: " + str(high_score)
	show()
	$OptionsMenu.hide()
	$VBoxContainer/StartContainer/StartButton.focus()


func _on_start_button_pressed():
	start_game.emit()

func _on_options_button_pressed():
	$OptionsMenu.show_and_focus()

func _on_controls_button_pressed() -> void:
	$ControlsMenu.show_and_focus()

func _on_quit_button_pressed():
	quit.emit()


func _on_options_menu_mute():
	mute.emit()

func _on_options_menu_worm_mode():
	worm_mode.emit()

func _on_options_menu_close():
	$OptionsMenu.hide()
	$VBoxContainer/OptionsContainer/OptionsButton.focus(true)


func _on_controls_menu_close() -> void:
	$ControlsMenu.hide()
	$VBoxContainer/ControlsContainer/ControlsButton.focus(true)
