extends Node

var score      : int
var save_data  : SaveData

func _ready():
	save_data = SaveData.load()
	start_screen()

## ------------- State-Chaging Functions -------------- ##

# start_screen opens the game's start screen, and sets the game state accordingly.
func start_screen():
	Global.set_game_state(Global.GameState.START_SCREEN)
	$AudioPlayer.stop_music()
	$Menus.show_start_screen()

# start_screen opens the game's main menu, and sets the game state accordingly.
func main_menu():
	Global.set_game_state(Global.GameState.MAIN_MENU)
	$AudioPlayer.stop_music()
	$Menus.show_main_menu(save_data.high_score)
	$Snake.kill_snake()
	$Snake.stop_ticker()

# start_game opens the game level in it's openning state, and starts Snake.
func start_game():
	
	# Reset game state
	score = 0
	Global.set_game_state(Global.GameState.PLAY)
	$AudioPlayer.increase_music_volume()
	
	# Start the game
	$Snake.update_score(score)
	$Snake.update_high_score(save_data.high_score)
	$Menus.hide_all()
	$Snake.spawn_new_snake()

# pause opens the game's pause menu, pauses Snake, and sets the game's state accordingly.
func pause():
	Global.set_game_state(Global.GameState.PAUSE)
	$AudioPlayer.lower_music_volume()
	$Menus.show_pause_menu()

# resume resumes Snake without reseting it to its openning state, and updates the game's
# state accordingly.
func resume():
	Global.set_game_state(Global.GameState.PLAY)
	$AudioPlayer.increase_music_volume()
	$Menus.hide_all()

# game_over ends Snake, opens the game's game-over menu, saves any new high-score and
# updates the game's state accordingly.
func game_over():
	
	# Kill the snake
	$Snake.kill_snake()
	
	# Update game state
	Global.set_game_state(Global.GameState.GAME_OVER)
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

# _on_snake_game_tick is triggered when a game tick occurs in-game.
func _on_snake_game_tick():
	if Global.game_state == Global.GameState.PLAY:
		$Snake.moveSnake()

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
	match Global.game_state:
		Global.GameState.MAIN_MENU, Global.GameState.GAME_OVER:
			start_game()
		Global.GameState.PAUSE:
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
	if Global.game_state == Global.GameState.START_SCREEN:
		main_menu()

# _on_player_input_pause is triggered when the player presses ESC.
func _on_player_input_pause():
	match Global.game_state: 
		Global.GameState.PLAY:
			pause()
		# TODO: Review this during tidy-up. It's a little hacky.
		Global.GameState.PAUSE:
			resume()

# _on_player_input_up is triggered when the player presses UP or W
func _on_player_input_up():
	turn_input(Vector2.UP)

# _on_player_input_right is triggered when the player presses RIGHT or D
func _on_player_input_right():
	turn_input(Vector2.RIGHT)

# _on_player_input_down is triggered when the player presses DOWN or S
func _on_player_input_down():
	turn_input(Vector2.DOWN)

# _on_player_input_left is triggered when the player presses LEFT or A
func _on_player_input_left():
	turn_input(Vector2.LEFT)

# turn_input handles the events that should occur when the player has input the provided
# direction.
func turn_input(direction:Vector2): 
	if Global.game_state == Global.GameState.PLAY:
		
		# Check if this is the first input direction
		if $Snake.is_waiting():
			$Snake.start_ticker()
		$AudioPlayer.play_music()
		
		# Turn the snake
		if $Snake.turn(direction):
			$AudioPlayer.play_turn()
