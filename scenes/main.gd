extends Node

enum GameState {START_SCREEN, MAIN_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState
var score : int
var save_data : SaveData
var worm_mode : bool # TODO: Add functionality to this

## ------------- State-Chaging Functions -------------- ##

func start_screen():
	$AudioPlayer.stop_music()
	game_state = GameState.START_SCREEN
	$Menus.show_start_screen()
	$HUD.hide()

func main_menu():
	$AudioPlayer.stop_music()
	if game_state == GameState.PAUSE:
		$AudioPlayer.play_game_over()
	
	game_state = GameState.MAIN_MENU
	$Menus.show_main_menu(save_data.high_score)
	$HUD.hide()
	$Snake.kill_snake()
	$Snake.stop_ticker()

func start_game():
	$AudioPlayer.increase_music_volume()
	$AudioPlayer.play_start_game()
	
	# Reset game state
	score = 0
	game_state = GameState.PLAY
	
	# Start the game
	$HUD.update_score(score)
	$HUD.update_high_score(save_data.high_score)
	$Menus.hide_all()
	$HUD.show()
	$Snake.spawn_new_snake()

func pause():
	# TODO: There's a bug here when the player pauses the game before the snake starts moving! 
	$AudioPlayer.lower_music_volume()
	$AudioPlayer.play_pause()
	game_state = GameState.PAUSE
	$Menus.show_pause_menu()
	$Snake.stop_ticker()

func resume():
	$AudioPlayer.increase_music_volume()
	$AudioPlayer.play_resume()
	game_state = GameState.PLAY
	$Menus.hide_all()
	$HUD.show()
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
	$Menus.show_game_over_screen(score)
	$Snake.stop_ticker()


## ------------- Event-Triggered Functions ------------- ##

func _ready():
	worm_mode = false # TODO: Add functionality to this
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
	$HUD.update_score(score)
	
	# Update high score if it's been beaten
	if score > save_data.high_score:
		$HUD.update_high_score(score)


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
	if !$AudioPlayer.muted:
		$AudioPlayer.mute()
		$Menus.set_mute_icons(true)
	else:
		$AudioPlayer.unmute()
		$Menus.set_mute_icons(false)

func _on_menus_worm_mode():
	if !worm_mode: 
		$Menus.set_worm_mode_icons(true)
		worm_mode = true
		print("TODO: WORM MODE NOW!")
	else: 
		$Menus.set_worm_mode_icons(false)
		worm_mode = false
		print("TODO: SNAKE MODE NOW!")


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
