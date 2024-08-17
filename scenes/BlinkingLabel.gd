extends Label

@export var active:bool
@export var number_of_blinks:int
@export var time_between_blinks:float
@export var vertical_speed:float

var lifetime:float = 0

func _ready():
	$Timer.set_wait_time(time_between_blinks)
	lifetime = number_of_blinks*time_between_blinks*2
	if active:
		$Timer.start()
	else:
		$Timer.stop()

func _process(delta):
	if active:
		position += Vector2(0,1)*vertical_speed*delta

func temporarily_activate(coords:Vector2):
	activate(coords)
	await get_tree().create_timer(lifetime).timeout
	disable()

func activate(coords:Vector2 = Vector2.ZERO):
	position = coords - size/2
	active = true
	show()
	$Timer.start()

func disable():
	active = false
	$Timer.stop()
	hide()

func _on_timer_timeout():
	if is_visible():
		hide()
	else:
		show()
