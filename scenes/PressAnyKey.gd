extends Label

func _on_timer_timeout():
	if is_visible():
		hide()
	else:
		show()
