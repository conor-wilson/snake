extends Control

signal resume
signal options
signal quit_to_main

func show_and_focus():
	show()
	$VBoxContainer/ResumeButton.grab_focus()

func _on_resume_button_pressed():
	resume.emit()

func _on_options_button_pressed():
	options.emit()

func _on_quit_to_main_menu_button_pressed():
	quit_to_main.emit()
