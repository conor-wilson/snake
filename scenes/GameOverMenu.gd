extends Control

signal try_again
signal main_menu

func show_and_focus(score:int = 0):
	show()
	$VBoxContainer/Score.text = "Score: " + str(score)
	$VBoxContainer/TryAgainButton.grab_focus()

func _on_try_again_button_pressed():
	try_again.emit()

func _on_main_menu_button_pressed():
	main_menu.emit()

