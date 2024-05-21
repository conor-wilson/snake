extends Control

signal play
signal options
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
	$MainMenu/OptionsMenu.hide()
	$MainMenu/VBoxContainer/StartContainer/StartButton.grab_focus()

func show_pause_menu():
	hide_all()
	$PauseMenu.show()
	$PauseMenu/VBoxContainer/ResumeContainer/ResumeButton.grab_focus()

func show_game_over_screen(score:int):
	hide_all()
	$GameOverMenu/VBoxContainer/Score.text = "Score: " + str(score)
	$GameOverMenu.show()
	$GameOverMenu/VBoxContainer/TryAgainContainer/TryAgainButton.grab_focus()


func _on_start_button_pressed():
	play.emit()

func _on_options_button_pressed():
	options.emit()

func _on_quit_button_pressed():
	quit.emit()

func _on_resume_button_pressed():
	play.emit()

func _on_main_menu_button_pressed():
	main_menu.emit()

func _on_try_again_button_pressed():
	play.emit()


func _on_main_options_button_pressed():
	$MainMenu/OptionsMenu.toggle_visibility()
	$MainMenu/OptionsMenu/VBoxContainer/MuteButton.grab_focus()

func _on_options_menu_close():
	$MainMenu/OptionsMenu.hide()
	$MainMenu/VBoxContainer/OptionsContainer/MainOptionsButton.grab_focus()
