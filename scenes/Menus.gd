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
	$StartScreen.hide()
	$MainMenu.hide()
	$PauseMenu.hide()
	$GameOverMenu.hide()

func show_start_screen():
	hide_all()
	$StartScreen.show_and_focus()

func show_main_menu(high_score:int):
	hide_all()
	$StartScreen.show()
	$MainMenu.show_and_focus(high_score)

func show_pause_menu():
	hide_all()
	$PauseMenu.show_and_focus()

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
	$MainMenu/OptionsMenu.set_mute_icon(checked) # TODO: Actually handle this with a global var
	$PauseMenu/OptionsMenu.set_mute_icon(checked) # TODO: Actually handle this with a global var

func set_worm_mode_icons(checked:bool):
	$MainMenu/OptionsMenu.set_worm_mode_icon(checked) # TODO: Actually handle this with a global var
	$PauseMenu/OptionsMenu.set_worm_mode_icon(checked) # TODO: Actually handle this with a global var


func _on_main_menu_start_game():
	play.emit()

func _on_main_menu_quit():
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

