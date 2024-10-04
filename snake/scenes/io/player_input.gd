extends Node

signal any
signal pause
signal up
signal right
signal down
signal left

func _process(delta):
	process_player_input()

# process_player_input detects which inputs have just been pressed by the player, and
# emits signals accordingly.
func process_player_input():
	
	if Input.is_anything_pressed():
		any.emit()
	if Input.is_action_just_pressed("esc"): 
		pause.emit()
	if Input.is_action_pressed("move_up"):
		up.emit()
	if Input.is_action_pressed("move_right"):
		right.emit()
	if Input.is_action_pressed("move_down"):
		down.emit()
	if Input.is_action_pressed("move_left"):
		left.emit()

## --------------- Swipe-Detection Funcs --------------- ##

func _on_swipe_detector_up() -> void:
	up.emit()

func _on_swipe_detector_left() -> void:
	left.emit()

func _on_swipe_detector_down() -> void:
	down.emit()

func _on_swipe_detector_right() -> void:
	right.emit()

func _on_swipe_detector_pause() -> void:
	pause.emit()
