extends Camera2D

signal up
signal right
signal down
signal left

signal pause

@export var swipe_length:int = 100
@export var directional_threshold:int = 50

var swiping:bool = false
var start_pos:Vector2

func _process(delta: float) -> void:
	check_swipe()

# check_swipe checks if a swipe has just occured. If one has, it instructs this Node to
# emit one of its directional signals.
func check_swipe():
	
	# Detect when swipe is beginning
	if Input.is_action_just_pressed("click") && !swiping:
		swiping = true
		start_pos = get_global_mouse_position()
	
	# Detect when the pause area has been clicked
	if Input.is_action_just_released("click"):
		if start_pos.distance_to(get_global_mouse_position()) < swipe_length && start_pos.y < 64:
			pause.emit()
	
	# Detect if the user is mid-swipe
	if Input.is_action_pressed("click") && swiping:
		var current_pos:Vector2 = get_global_mouse_position()
		if start_pos.distance_to(current_pos) >= swipe_length:
			emit_swipe(current_pos)
			swiping = false
	
	# Otherwise, we're not swiping anymore
	else:
		swiping = false

# emit_swipe determines the direction of the current swipe based on the provided
# current position vector, and outputs one of the Node's signals accordingly.
func emit_swipe(current_pos:Vector2):
	
	# Skip output if we're not swiping
	if !swiping: 
		pass
	
	# Calculate the direction and emit accordingly
	if start_pos.y - current_pos.y > directional_threshold:
		up.emit()
	if current_pos.x - start_pos.x > directional_threshold:
		right.emit()
	if current_pos.y - start_pos.y > directional_threshold:
		down.emit()
	if start_pos.x - current_pos.x > directional_threshold:
		left.emit()
