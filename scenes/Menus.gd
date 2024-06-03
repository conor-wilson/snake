extends Control

@export var game_over_timeout:float 

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
	#$StartScreen/PressAnyKey/Timer.stop()
	$StartScreen.hide()
	$MainMenu.hide()
	$PauseMenu.hide()
	$GameOverMenu.hide()

func show_start_screen():
	hide_all()
	$StartScreen.show_and_focus()

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
	$MainMenu/MainOptionsMenu/VBoxContainer/MuteContainer/MuteButton.grab_focus()

func show_pause_menu():
	hide_all()
	$PauseMenu.show()
	$PauseMenu/PauseOptionsMenu.hide()
	$PauseMenu/VBoxContainer/ResumeContainer/ResumeButton.grab_focus()

func show_game_over_screen(score:int, new_high_score:bool):
	
	await get_tree().create_timer(game_over_timeout).timeout
	
	hide_all()
	$GameOverMenu/VBoxContainer/Score.text = "Score: " + str(score)
	$GameOverMenu.show()
	$GameOverMenu/VBoxContainer/TryAgainContainer/TryAgainButton.grab_focus()
	
	if new_high_score:
		$GameOverMenu/NewHighScore.show()
	else:
		$GameOverMenu/NewHighScore.hide()

func set_mute_icons(checked:bool):
	$MainMenu/MainOptionsMenu.set_mute_icon(checked)
	$PauseMenu/PauseOptionsMenu.set_mute_icon(checked)

func set_worm_mode_icons(checked:bool):
	$MainMenu/MainOptionsMenu.set_worm_mode_icon(checked)
	$PauseMenu/PauseOptionsMenu.set_worm_mode_icon(checked)

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

func _on_options_menu_mute():
	mute.emit()

func _on_options_menu_worm_mode():
	worm_mode.emit()

## ------ Options Popup Menu Behaviour ------ ##

func _on_main_options_button_pressed():
	$MainMenu/MainOptionsMenu.show_and_focus(true) # TODO: Worm Mode

func _on_pause_options_button_pressed():
	$PauseMenu/PauseOptionsMenu.show_and_focus(true) # TODO: Worm Mode

func _on_main_options_menu_close():
	$MainMenu/MainOptionsMenu.hide()
	$MainMenu/VBoxContainer/OptionsContainer/MainOptionsButton.grab_focus()

func _on_pause_options_menu_close():
	$PauseMenu/PauseOptionsMenu.hide()
	$PauseMenu/VBoxContainer/OptionsContainer/PauseOptionsButton.grab_focus()
