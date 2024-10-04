extends Label

@export var active:bool               # If true, the blinking-label will enter the tree activated.
@export var number_of_blinks:int      # The number of blinks that occur when using temporarily_activate().
@export var blink_duration:float      # The duration that the label is shown during a blink.
@export var time_between_blinks:float # The duration that the label is hidden between blinks.
@export var vertical_speed:float      # The speed at which the label will float vertically while blinking.
@export var horizontal_speed:float    # The speed at which the label will float horizontally while blinking.

var lifetime:float # How long the label stays active until deactivating when using temporarily_activate().

func _ready():
	lifetime = number_of_blinks*(blink_duration+time_between_blinks)
	if active:
		activate(Vector2(-1,-1))
	else:
		disable()

func _process(delta):
	if active:
		position += Vector2(horizontal_speed, vertical_speed) * delta

# activate activates the blinking label, optionally placing it at the provided coordinates.
func activate(coords:Vector2 = Vector2(-1,-1)):
	
	if coords.x >= 0 && coords.y >= 0:
		position = coords - size/2
	
	active = true
	start_blinking()

# disable disables the blinking label, and hides it.
func disable():
	active = false
	$ShowTimer.stop()
	$HideTimer.stop()
	hide()

# temporarily_activate temporarily activates the blinking label at the provided screen
# coordinates.
func temporarily_activate(coords:Vector2):
	activate(coords)
	await get_tree().create_timer(lifetime).timeout
	disable()

# start_blinking starts the blinking process by starting both timers, and offsetting
# their start times so that the configured timing-settings are applied.
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
