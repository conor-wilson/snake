extends Control

@export var game_over_timeout:float # The delay that should occur between when the player dies and when the game-over menu appears

signal play
signal mute
signal worm_mode
signal quit
signal main_menu

func _ready():
	hide_all()

# hide_all hides all the menus.
func hide_all():
	$StartScreen.hide()
	$MainMenu.hide()
	$PauseMenu.hide()
	$GameOverMenu.hide()


## ---------------- Menu-Showing Funcs ----------------- ##

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

func show_game_over_screen(score:int, new_high_score:bool, worm_mode_unlocked:bool):
	
	# Wait briefly so the player can see how they died
	await get_tree().create_timer(game_over_timeout).timeout
	
	hide_all()
	$GameOverMenu.show_and_focus(score, new_high_score, worm_mode_unlocked)


## ---------------- Button-Signal Funcs ---------------- ##

func _on_start_button_pressed():
	play.emit()

func _on_resume_button_pressed():
	play.emit()

func _on_try_again_button_pressed():
	play.emit()

func _on_mute_button_pressed():
	mute.emit()

func _on_worm_mode_button_pressed():
	worm_mode.emit()
	$StartScreen.update_mode()

func _on_main_menu_button_pressed():
	main_menu.emit()

func _on_quit_button_pressed():
	quit.emit()
