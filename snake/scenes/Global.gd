extends Node

enum GameState {START_SCREEN, MAIN_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState
var mute:bool      = false
var worm_mode:bool = false

func toggle_mute():
	mute = !mute

func toggle_worm_mode():
	worm_mode = !worm_mode

func set_game_state(state:GameState):
	game_state = state
