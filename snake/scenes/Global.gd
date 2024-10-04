extends Node

## The Global class contains all  global settings that need to be accessible for multiple
## different scenes at once, as well as the functions used to control them.

var mute:bool      = false
var worm_mode:bool = false

func toggle_mute():
	mute = !mute

func toggle_worm_mode():
	worm_mode = !worm_mode
