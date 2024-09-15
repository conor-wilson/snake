extends Label

@export var active:bool
@export var number_of_blinks:int
@export var blink_duration:float
@export var time_between_blinks:float
@export var vertical_speed:float
@export var horizontal_speed:float

var lifetime:float = 0

func _ready():
	lifetime = number_of_blinks*(blink_duration+time_between_blinks)
	if active:
		activate()
	else:
		disable()

func _process(delta):
	if active:
		position += Vector2(horizontal_speed, vertical_speed) * delta

func activate(coords:Vector2 = Vector2(-1,-1)):
	
	if coords.x >= 0 && coords.y >= 0:
		position = coords - size/2
	
	active = true
	start_blinking()

func disable():
	active = false
	$ShowTimer.stop()
	$HideTimer.stop()
	hide()
	
func temporarily_activate(coords:Vector2):
	activate(coords)
	await get_tree().create_timer(lifetime).timeout
	disable()

func start_blinking():
	show()
	$ShowTimer.start(blink_duration+time_between_blinks)
	await get_tree().create_timer(blink_duration).timeout
	hide()
	$HideTimer.start(blink_duration+time_between_blinks)

func _on_show_timer_timeout():
	show()

func _on_hide_timer_timeout():
	hide()
