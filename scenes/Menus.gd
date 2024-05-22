extends Control

#TODO: Restructure this file, and think about splitting this scene up.

signal play
signal mute
signal worm_mode
signal quit
signal main_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all()

func hide_all():
	$StartScreen/PressAnyKey/Timer.stop()
	$StartScreen.hide()
	$MainMenu.hide()
	$PauseMenu.hide()
	$GameOverMenu.hide()

func show_start_screen():
	hide_all()
	$StartScreen.show()
	$StartScreen/PressAnyKey/Timer.start()

func show_main_menu(high_score:int):
	hide_all()
	$MainMenu/HighScore.text = "High Score: " + str(high_score)
	$StartScreen.show()
	$MainMenu.show()
	$MainMenu/MainOptionsMenu.hide()
	$MainMenu/VBoxContainer/StartContainer/StartButton.grab_focus()

func show_main_options_menu():
	hide_all()
	$StartScreen.show()
	$MainMenu.show()
	$MainMenu/MainOptionsMenu.toggle_visibility()
	$MainMenu/MainOptionsMenu/VBoxContainer/MuteButton.grab_focus()

func show_pause_menu():
	hide_all()
	$PauseMenu.show()
	$PauseMenu/PauseOptionsMenu.hide()
	$PauseMenu/VBoxContainer/ResumeContainer/ResumeButton.grab_focus()

func show_game_over_screen(score:int):
	hide_all()
	$GameOverMenu/VBoxContainer/Score.text = "Score: " + str(score)
	$GameOverMenu.show()
	$GameOverMenu/VBoxContainer/TryAgainContainer/TryAgainButton.grab_focus()


func _on_start_button_pressed():
	play.emit()

func _on_quit_button_pressed():
	quit.emit()

func _on_resume_button_pressed():
	play.emit()

func _on_main_menu_button_pressed():
	main_menu.emit()

func _on_try_again_button_pressed():
	play.emit()

## ------ Options Popup Menu Behaviour ------ ##

func _on_main_options_button_pressed():
	$MainMenu/MainOptionsMenu.toggle_visibility()
	$MainMenu/MainOptionsMenu/VBoxContainer/MuteButton.grab_focus()

func _on_pause_options_button_pressed():
	$PauseMenu/PauseOptionsMenu.toggle_visibility()
	$PauseMenu/PauseOptionsMenu/VBoxContainer/MuteButton.grab_focus()

func _on_main_options_menu_close():
	$MainMenu/MainOptionsMenu.hide()
	$MainMenu/VBoxContainer/OptionsContainer/MainOptionsButton.grab_focus()

func _on_pause_options_menu_close():
	$PauseMenu/PauseOptionsMenu.hide()
	$PauseMenu/VBoxContainer/OptionsContainer/PauseOptionsButton.grab_focus()
