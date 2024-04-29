extends Node

enum GameState {START_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState
var score : int


## ------------- State-Chaging Functions -------------- ##

func start_menu():
	game_state = GameState.START_MENU
	$HUD.show_start_menu()
	$Snake.stop_ticker()

func start_game():
	score = 0
	game_state = GameState.PLAY
	$HUD.show_in_game_hud()
	$Snake.spawn_new_snake()
	$Snake.start_ticker()

func pause():
	game_state = GameState.PAUSE
	$HUD.show_pause_menu()
	$Snake.stop_ticker()

func resume():
	game_state = GameState.PLAY
	$HUD.show_in_game_hud()
	$Snake.start_ticker()

func game_over():
	game_state = GameState.GAME_OVER
	$HUD.show_game_over_screen()
	$Snake.stop_ticker()


## ------------- Event-Triggered Functions ------------- ##

func _ready():
	start_menu()

func _on_snake_hit():
	game_over()

func _on_snake_apple_eaten():
	score += 1

func _on_hud_start_game():
	match game_state:
		GameState.START_MENU, GameState.GAME_OVER:
			start_game()
		GameState.PAUSE:
			resume()


## ---------- Player-Input-Triggered Functions --------- ##

func _on_player_input_esc():
	match game_state: 
		GameState.PLAY:
			pause()
		# TODO: Review this during tidy-up. It's a little hacky.
		GameState.PAUSE:
			resume()

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
