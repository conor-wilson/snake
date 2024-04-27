extends Node

signal esc
signal up
signal right
signal down
signal left

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_player_input()

# TODO: Descriptor
func process_player_input():
	
	if Input.is_action_just_pressed("pause"): 
		esc.emit()
	if Input.is_action_pressed("move_up"):
		up.emit()
	if Input.is_action_pressed("move_right"):
		right.emit()
	if Input.is_action_pressed("move_down"):
		down.emit()
	if Input.is_action_pressed("move_left"):
		left.emit()
