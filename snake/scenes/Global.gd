extends Node

## The Global class contains all global vars and consts that need to be accessible for
## multiple scenes at once, as well as the functions used to control them.

# WORM_MODE_THRESHOLD defines 
const WORM_MODE_THRESHOLD : int = 50 # The high-score threshold after which WORM MODE will be unlocked.
var   mute      : bool = false       # If true, the game's music and sound effects will be muted
var   worm_mode : bool = false       # If true, WORM MODE will be activated

# toggle_mute toggles the global mute variable.
func toggle_mute():
	mute = !mute

# toggle_worm_mode toggles the global worm_mode variable.
func toggle_worm_mode():
	worm_mode = !worm_mode
