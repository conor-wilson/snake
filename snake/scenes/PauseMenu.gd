extends Control

signal resume
signal mute
signal worm_mode
signal main_menu

func show_and_focus():
	show()
	$OptionsMenu.hide()
	$VBoxContainer/ResumeContainer/ResumeButton.focus()


func _on_resume_button_pressed():
	resume.emit()

func _on_options_button_pressed():
	$OptionsMenu.show_and_focus()

func _on_main_menu_button_pressed():
	main_menu.emit()


func _on_options_menu_mute():
	mute.emit()

func _on_options_menu_worm_mode():
	worm_mode.emit()

func _on_options_menu_close():
	$OptionsMenu.hide()
	$VBoxContainer/OptionsContainer/OptionsButton.focus(true)
