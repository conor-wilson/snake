extends Node

enum GameState {START_SCREEN, MAIN_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState
var score      : int
var save_data  : SaveData

## ------------- State-Chaging Functions -------------- ##

func start_screen():
	$AudioPlayer.stop_music()
	game_state = GameState.START_SCREEN
	$Menus.show_start_screen()

func main_menu():
	$AudioPlayer.stop_music()
	
	game_state = GameState.MAIN_MENU
	$Menus.show_main_menu(save_data.high_score)
	$Snake.kill_snake()
	$Snake.stop_ticker()

func start_game():
	$AudioPlayer.increase_music_volume()
	
	# Reset game state
	score = 0
	game_state = GameState.PLAY
	
	# Start the game
	$Snake.update_score(score)
	$Snake.update_high_score(save_data.high_score)
	$Menus.hide_all()
	$Snake.spawn_new_snake()

func pause():
	# TODO: There's a bug here when the player pauses the game before the snake starts moving! 
	$AudioPlayer.lower_music_volume()
	game_state = GameState.PAUSE
	$Menus.show_pause_menu()
	$Snake.stop_ticker()

func resume():
	$AudioPlayer.increase_music_volume()
	game_state = GameState.PLAY
	$Menus.hide_all()
	$Snake.start_ticker()

func game_over():
	$AudioPlayer.stop_music()
	$AudioPlayer.play_game_over()
	
	# Update game state
	game_state = GameState.GAME_OVER
	
	# Determine if WORM MODE has just been unlocked
	var worm_mode_unlocked : bool = score >= save_data.WORM_MODE_THRESHOLD && !save_data.worm_mode_unlocked
	
	# If there's a new high-score, save it!
	var new_high_score : bool = score > save_data.high_score
	if new_high_score:
		save_data.save_new_high_score(score)
	
	# Update HUD
	$Menus.show_game_over_screen(score, new_high_score, worm_mode_unlocked)
	$Snake.stop_ticker()


## ------------- Event-Triggered Functions ------------- ##

func _ready():
	save_data = SaveData.load()
	start_screen()

func _on_snake_turn():
	$AudioPlayer.play_turn()

func _on_snake_hit():
	$Snake.kill_snake()
	game_over()

func _on_snake_apple_eaten():
	$AudioPlayer.play_apple_collect()
	
	# Update score
	score += 1
	$Snake.update_score(score)
	
	# Update high score if it's been beaten
	if score > save_data.high_score:
		
		if score == save_data.WORM_MODE_THRESHOLD && !save_data.worm_mode_unlocked:
			$Snake.worm_mode_unlocked()
		elif score == save_data.high_score+1: 
			$Snake.new_high_score()
		
		$Snake.update_high_score(score)


## ----------- Menu-Triggered Functions ---------- ##

func _on_menus_play():
	match game_state:
		GameState.MAIN_MENU, GameState.GAME_OVER:
			start_game()
		GameState.PAUSE:
			resume()

func _on_menus_quit():
	get_tree().quit()

func _on_menus_main_menu():
	start_screen()

func _on_menus_mute():
	Global.toggle_mute()
	$AudioPlayer.stop_music_if_muted()

func _on_menus_worm_mode():
	Global.toggle_worm_mode()
	$Snake.update_mode()


## ---------- Player-Input-Triggered Functions --------- ##

func _on_player_input_any():
	if game_state == GameState.START_SCREEN:
		main_menu()

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
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.UP)

func _on_player_input_right():
	if game_state == GameState.PLAY:
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.RIGHT)

func _on_player_input_down():
	if game_state == GameState.PLAY:
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.DOWN)

func _on_player_input_left():
	if game_state == GameState.PLAY:
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.LEFT)
