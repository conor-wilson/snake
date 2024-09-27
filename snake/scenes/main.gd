extends Node

enum GameState {START_SCREEN, MAIN_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState
var score      : int
var save_data  : SaveData

func _ready():
	save_data = SaveData.load()
	start_screen()

## ------------- State-Chaging Functions -------------- ##

# start_screen opens the game's start screen, and sets the game state accordingly.
func start_screen():
	game_state = GameState.START_SCREEN
	$AudioPlayer.stop_music()
	$Menus.show_start_screen()

# start_screen opens the game's main menu, and sets the game state accordingly.
func main_menu():
	game_state = GameState.MAIN_MENU
	$AudioPlayer.stop_music()
	$Menus.show_main_menu(save_data.high_score)
	$Snake.kill_snake()
	$Snake.stop_ticker()

# start_game opens the game level in it's openning state, and starts Snake.
func start_game():
	
	# Reset game state
	score = 0
	game_state = GameState.PLAY
	$AudioPlayer.increase_music_volume()
	
	# Start the game
	$Snake.update_score(score)
	$Snake.update_high_score(save_data.high_score)
	$Menus.hide_all()
	$Snake.spawn_new_snake()

# pause opens the game's pause menu, pauses Snake, and sets the game's state accordingly.
func pause():
	# TODO: There's a bug here when the player pauses the game before the snake starts moving!
	game_state = GameState.PAUSE
	$AudioPlayer.lower_music_volume()
	$Menus.show_pause_menu()
	$Snake.stop_ticker()

# resume resumes Snake without reseting it to its openning state, and updates the game's
# state accordingly.
func resume():
	game_state = GameState.PLAY
	$AudioPlayer.increase_music_volume()
	$Menus.hide_all()
	$Snake.start_ticker()

# game_over ends Snake, opens the game's game-over menu, saves any new high-score and
# updates the game's state accordingly.
func game_over():
	
	# Kill the snake
	$Snake.kill_snake()
	
	# Update game state
	game_state = GameState.GAME_OVER
	$AudioPlayer.stop_music()
	$AudioPlayer.play_game_over()
	$Snake.stop_ticker()
	
	# Determine if WORM MODE has just been unlocked
	var worm_mode_unlocked : bool = score >= save_data.WORM_MODE_THRESHOLD && !save_data.worm_mode_unlocked
	
	# If there's a new high-score, save it!
	var new_high_score : bool = score > save_data.high_score
	if new_high_score:
		save_data.save_new_high_score(score)
	
	# Update HUD
	$Menus.show_game_over_screen(score, new_high_score, worm_mode_unlocked)


## ------------- Event-Triggered Functions ------------- ##

# _on_snake_turn is triggered when the snake turns in-game.
func _on_snake_turn():
	$AudioPlayer.play_turn()

# _on_snake_hit is triggered when the snake crashes into the wall or itself.
func _on_snake_hit():
	game_over()

# _on_snake_apple_eaten is triggered when the snake eats an apple in-game.
func _on_snake_apple_eaten():
	
	# Update score
	score += 1
	$Snake.update_score(score)
	$AudioPlayer.play_apple_collect()
	
	# Update high score if it's been beaten
	if score > save_data.high_score:
		
		if score == save_data.WORM_MODE_THRESHOLD && !save_data.worm_mode_unlocked:
			$Snake.worm_mode_unlocked()
		elif score == save_data.high_score+1: 
			$Snake.new_high_score()
		
		$Snake.update_high_score(score)


## ----------- Menu-Triggered Functions ---------- ##

# _on_menu_play is triggered when the START, RESUME or TRY AGAIN buttons are clicked
# within any of the menus.
func _on_menus_play():
	match game_state:
		GameState.MAIN_MENU, GameState.GAME_OVER:
			start_game()
		GameState.PAUSE:
			resume()

# _on_menus_quit is triggered when the QUIT menu is clicked within the main menu.
func _on_menus_quit():
	get_tree().quit()

# _on_menus_main_menu is triggered when the MAIN MENU button is clicked within any of the
#  menus.
func _on_menus_main_menu():
	start_screen()

# _on_menus_mute is triggered when the MUTE button is clicked within the options menu.
func _on_menus_mute():
	Global.toggle_mute()
	$AudioPlayer.stop_music_if_muted()

# _on_menus_worm_mode is triggered when the WORM MODE is clicked within the options menu.
func _on_menus_worm_mode():
	Global.toggle_worm_mode()
	$Snake.update_mode()


## ---------- Player-Input-Triggered Functions --------- ##

# _on_player_input_any is triggered when the player provides any input.
func _on_player_input_any():
	if game_state == GameState.START_SCREEN:
		main_menu()

# _on_player_input_pause is triggered when the player presses ESC.
func _on_player_input_pause():
	match game_state: 
		GameState.PLAY:
			pause()
		# TODO: Review this during tidy-up. It's a little hacky.
		GameState.PAUSE:
			resume()

# TODO: Fix the way that these funcs handle the first player input. It's janky.

# _on_player_input_up is triggered when the player presses UP or W
func _on_player_input_up():
	if game_state == GameState.PLAY:
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.UP)
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()

# _on_player_input_right is triggered when the player presses RIGHT or D
func _on_player_input_right():
	if game_state == GameState.PLAY:
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.RIGHT)
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()

# _on_player_input_down is triggered when the player presses DOWN or S
func _on_player_input_down():
	if game_state == GameState.PLAY:
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.DOWN)
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()

# _on_player_input_left is triggered when the player presses LEFT or A
func _on_player_input_left():
	if game_state == GameState.PLAY:
		$Snake.start_ticker()
		$Snake.turn_head(Vector2.LEFT)
		$AudioPlayer.play_turn()
		$AudioPlayer.play_music()
