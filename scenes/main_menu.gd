extends Control

signal start_game # TODO: Rename this to "play"
signal options_menu # TODO: Rename this to "options"
signal quit

func show_and_focus():
	show()
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	start_game.emit()

func _on_options_button_pressed():
	options_menu.emit()

func _on_quit_button_pressed():
	quit.emit()
