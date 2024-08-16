extends Label

func activate():
	show()
	$Timer.start()

func disable():
	$Timer.stop()
	hide()

func _on_timer_timeout():
	if is_visible():
		hide()
	else:
		show()
