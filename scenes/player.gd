extends Area2D

@export var speed = 200      # Pixels/second
@export var snakeRadius = 32 # Diameter of snake's tube

# TODO: Maybe these belong in the Main scene?
var tile_size   = 64
var margin_size = 64

# The cardinal direction of the snake's head: 
# 0 == up
# 1 == right
# 2 == down
# 3 == left
# TODO: Change this to a Vector2
var direction = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = 0
	# TODO: Add starting position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Rotate the player sprite from the player input
	update_direction_from_input()
	#rotate_head()
	
	# Move the sprite according to player input
	#move(delta)


# rotate_from_input (TODO)
func update_direction_from_input():
	# TODO: Fix bug where the player can go 180 degrees by quickly pressing 2 buttons.
	if Input.is_action_pressed("move_up") && direction != 2:
		direction = 0
	if Input.is_action_pressed("move_right") && direction != 3:
		direction = 1
	if Input.is_action_pressed("move_down") && direction != 0:
		direction = 2
	if Input.is_action_pressed("move_left") && direction != 1:
		direction = 3


# rotate_head (TODO)
# TODO: Maybe this belongs to the AnimatedSprite2D Node?
func rotate_head():
	rotation = direction * PI/2


func _on_move_timer_timeout():
	
	# Rotate the snake's head according to the player input
	rotate_head()
	
	# TODO: Think about changing this to just use the direction vector (when it becomes a vector)
	# Change the position of the player sprite
	position += Vector2.UP.rotated(rotation) * tile_size
	
	# TODO: Maybe move the clamping to the Main scene
	# Clamp the position to the screen size
	var topLeft = (tile_size/2+margin_size)*Vector2.ONE
	var bottomRight = get_viewport_rect().size - (tile_size/2+margin_size)*Vector2.ONE
	position = position.clamp(topLeft, bottomRight)
