extends Button

# Checked and Unchecked box icon artwork
var unchecked_icon = preload("res://art/checkBoxUnchecked.png")
var checked_icon = preload("res://art/checkBoxChecked.png")

# TODO: Descriptor
@export var checkable : bool
@export var invert_mute_behavior : bool

# TODO: Descriptor
enum MenuSound {NOTHING, START_GAME, SELECT, CONFIRM, CANCEL}
@export var focus_sound   : MenuSound = MenuSound.SELECT
@export var pressed_sound : MenuSound = MenuSound.CONFIRM

var skip_next_focus_sound : bool = false

func _ready(): 
	if checkable: 
		icon = checked_icon

func focus(skip_sound:bool=false):
	self.skip_next_focus_sound = skip_sound
	grab_focus()

# TODO: Descriptor
func _on_focus_entered():
	if !skip_next_focus_sound && !Global.mute:
		play_sound(focus_sound)
	else: 
		skip_next_focus_sound = false

# TODO: Descriptor
func _on_pressed():
	
	# Play the desired audio
	if Global.mute == invert_mute_behavior:
		play_sound(pressed_sound)


# TODO: Descriptor
func play_sound(sound:MenuSound):
	match sound:
		MenuSound.NOTHING:
			pass
		MenuSound.SELECT:
			$SelectSound.play()
		MenuSound.CONFIRM:
			$ConfirmSound.play()
		MenuSound.CANCEL:
			$CancelSound.play()
		MenuSound.START_GAME:
			$StartGameSound.play()

# TODO: Descriptor
# TODO: Maybe use inheritance for this instead of this...
func update_icon(checked:bool): 
	if checkable: 
		icon = get_checkbox_icon(checked)
	else:
		print_debug("update_icon() was called on non-checkable menu button:", checked)

# TODO: Descriptor
func get_checkbox_icon(checked:bool) -> Resource:
	if checked:
		return checked_icon
	else:
		return unchecked_icon
