extends Node2D

enum GameState {START_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = GameState.START_MENU
	$HUD.show_start_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# TODO: descriptor
func _on_snake_hit():
	game_state = GameState.GAME_OVER
	$HUD.show_game_over_screen()
	$Snake.stop_ticker()


func _on_hud_start_game():
	game_state = GameState.PLAY
	$Snake.spawn_new_snake()
	$Snake.start_ticker()
	$HUD.show_in_game_hud()


func _on_player_input_esc():
	game_state = GameState.PAUSE
	$Snake.stop_ticker()

func _on_player_input_up():
	if game_state == GameState.PLAY:
		$Snake.move_up()

func _on_player_input_right():
	if game_state == GameState.PLAY:
		$Snake.move_right()

func _on_player_input_down():
	if game_state == GameState.PLAY:
		$Snake.move_down()

func _on_player_input_left():
	if game_state == GameState.PLAY:
		$Snake.move_left()
