extends Control

signal play
signal options
signal quit
signal main_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all()

func hide_all():
	$MainMenu.hide()
	$PauseMenu.hide()
	$GameOverMenu.hide()

func show_start_menu():
	hide_all()
	$MainMenu.show_and_focus()

func show_pause_menu():
	hide_all()
	$PauseMenu.show_and_focus()

func show_game_over_screen(score: int):
	hide_all()
	$GameOverMenu.show_and_focus(score)

func show_in_game_hud():
	hide_all()


func _on_main_menu_start_game():
	play.emit()

func _on_main_menu_options_menu():
	options.emit()

func _on_main_menu_quit():
	quit.emit()


func _on_pause_menu_resume():
	play.emit()

func _on_pause_menu_options():
	options.emit()

func _on_pause_menu_quit_to_main():
	main_menu.emit()


func _on_game_over_menu_try_again():
	play.emit()

func _on_game_over_menu_main_menu():
	main_menu.emit()

