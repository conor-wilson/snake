extends Control

signal try_again
signal main_menu

func show_and_focus(score:int, new_high_score:bool):
	
	$VBoxContainer/Score.text = "Score: " + str(score)
	show()
	$VBoxContainer/TryAgainContainer/TryAgainButton.focus(true)
	
	# TODO: Try $NewHighScore.visible = new_high_score
	if new_high_score:
		$NewHighScore.activate()
	else:
		$NewHighScore.disable()


func _on_try_again_button_pressed():
	try_again.emit()

func _on_main_menu_button_pressed():
	main_menu.emit()
