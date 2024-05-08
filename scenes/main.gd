extends Node

enum GameState {START_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState
var score : int
var save_data : SaveData


## ------------- State-Chaging Functions -------------- ##

func start_menu():
	game_state = GameState.START_MENU
	$HUD.show_start_menu()
	$Snake.stop_ticker()

func start_game():
	$AudioPlayer.play_start_game()
	
	# Reset game state
	score = 0
	game_state = GameState.PLAY
	
	# Start the game
	$HUD.update_score(score)
	$HUD.update_high_score(save_data.high_score)
	$HUD.show_in_game_hud()
	$Snake.spawn_new_snake()

func pause():
	# TODO: There's a bug here when the player pauses the game before the snake starts moving! 
	$AudioPlayer.lower_music_volume()
	$AudioPlayer.play_pause()
	game_state = GameState.PAUSE
	$HUD.show_pause_menu()
	$Snake.stop_ticker()

func resume():
	$AudioPlayer.increase_music_volume()
	$AudioPlayer.play_resume()
	game_state = GameState.PLAY
	$HUD.show_in_game_hud()
	$Snake.start_ticker()

func game_over():
	$AudioPlayer.stop_music()
	$AudioPlayer.play_game_over()
	
	# Update game state
	game_state = GameState.GAME_OVER
	
	# If there's a new high-score, save it!
	if score > save_data.high_score:
		save_data.save_new_high_score(score)
	
	# Update HUD
	$HUD.show_game_over_screen(score)
	$Snake.stop_ticker()


## ------------- Event-Triggered Functions ------------- ##

func _ready():
	save_data = SaveData.load()
	start_menu()

func _on_snake_turn():
	$AudioPlayer.play_turn()

func _on_snake_hit():
	game_over()

func _on_snake_apple_eaten():
	$AudioPlayer.play_apple_collect()
	
	# Update score
	score += 1
	$HUD.update_score(score)
	
	# Update high score if it's been beaten
	if score > save_data.high_score:
		$HUD.update_high_score(score)

func _on_hud_start_game():
	match game_state:
		GameState.START_MENU, GameState.GAME_OVER:
			start_game()
		GameState.PAUSE:
			resume()

func _on_hud_options():
	print("TODO: LOAD OPTIONS MENU NOW!")

func _on_hud_quit():
	get_tree().quit()


## ---------- Player-Input-Triggered Functions --------- ##

func _on_player_input_pause():
	match game_state: 
		GameState.PLAY:
			pause()
		# TODO: Review this during tidy-up. It's a little hacky.
		GameState.PAUSE:
			resume()

# TODO: Fix the way that these funcs handle the first player input. It's janky.

func _on_player_input_up():
	if game_state == GameState.PLAY:
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.UP)

func _on_player_input_right():
	if game_state == GameState.PLAY:
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.RIGHT)

func _on_player_input_down():
	if game_state == GameState.PLAY:
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.DOWN)

func _on_player_input_left():
	if game_state == GameState.PLAY:
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.LEFT)
