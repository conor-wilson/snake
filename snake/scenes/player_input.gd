extends Node

signal any
signal pause
signal up
signal right
signal down
signal left

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_player_input()

# TODO: Descriptor
func process_player_input():
	
	if Input.is_anything_pressed():
		any.emit()
	if Input.is_action_just_pressed("esc"): 
		pause.emit()
	#if Input.is_action_just_pressed("select"):
		#pause.emit() (TODO)
	if Input.is_action_pressed("move_up"):
		up.emit()
	if Input.is_action_pressed("move_right"):
		right.emit()
	if Input.is_action_pressed("move_down"):
		down.emit()
	if Input.is_action_pressed("move_left"):
		left.emit()
		
