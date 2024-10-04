extends Button

# Checked and Unchecked box icon artwork
var unchecked_icon = preload("res://scenes/menus/components/checkBoxUnchecked.png")
var checked_icon = preload("res://scenes/menus/components/checkBoxChecked.png")

@export var checkable : bool            # If true, the button will include a check-box next to it.
@export var invert_mute_behavior : bool # If true, the button will make noise when the game is muted and visa versa (useful when this is the mute button itself).

enum MenuSound {NOTHING, START_GAME, SELECT, CONFIRM, CANCEL}
@export var focus_sound   : MenuSound = MenuSound.SELECT  # The sound that is emitted when the MenuButton grabs focus.
@export var pressed_sound : MenuSound = MenuSound.CONFIRM # The sound that is emitted when the menuButton is pressed.

var skip_next_focus_sound : bool = false # If true, the next time this button grabs focus, it will not emit the focus noise.

func _ready(): 
	if checkable: 
		icon = checked_icon

# focus grabs focus to the MenuButton, skipping the focus sound if skip_sound is true.
func focus(skip_sound:bool=false):
	self.skip_next_focus_sound = skip_sound
	grab_focus()

# update_icon updates the button's check-box icon according to the provided checked bool
# (as long as this is a checkable MenuButton).
func update_icon(checked:bool): 
	if checkable: 
		icon = get_checkbox_icon(checked)
	else:
		print_debug("update_icon() was called on non-checkable menu button:", checked)

# get_checkbox_icon returns either the checked_icon resource or the unchecked_icon
# resorce depending on the provided value of checked.
func get_checkbox_icon(checked:bool) -> Resource:
	if checked:
		return checked_icon
	else:
		return unchecked_icon


## --------------- Sound-Emmitting Funcs --------------- ##

func _on_focus_entered():
	if !skip_next_focus_sound && !Global.mute:
		play_sound(focus_sound)
	else: 
		skip_next_focus_sound = false

func _on_pressed():
	if Global.mute == invert_mute_behavior:
		play_sound(pressed_sound)

# play_sound plays the provided MenuSound.
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
