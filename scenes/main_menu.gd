extends Control

signal start_game
signal options_menu
signal quit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func hide_all():
	$MainMenu.hide()

func show_start_menu():
	hide_all() # Hide all active HUD items
	$MainMenu.show()
	$MainMenu/VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	start_game.emit()

func _on_options_button_pressed():
	options_menu.emit()

func _on_quit_button_pressed():
	quit.emit()
