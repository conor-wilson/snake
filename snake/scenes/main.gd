extends Node

var score      : int
var save_data  : SaveData

# GameState represents the state that the game is in (ie: in-game, in a menu, etc...)
enum GameState {START_SCREEN, MAIN_MENU, PLAY, PAUSE, GAME_OVER}
var game_state : GameState

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
	$Game.stop_ticker()

# start_game opens the game level in it's openning state, and starts Snake.
func start_game():
	
	# Reset game state
	score = 0
	game_state = GameState.PLAY
	$AudioPlayer.increase_music_volume()
	
	# Start the game
	$Game.update_score(score)
	$Game.update_high_score(save_data.high_score)
	$Menus.hide_all()
	$Game.new_game()

# pause opens the game's pause menu, pauses Snake, and sets the game's state accordingly.
func pause():
	game_state = GameState.PAUSE
	$AudioPlayer.lower_music_volume()
	$Menus.show_pause_menu()

# resume resumes Snake without reseting it to its openning state, and updates the game's
# state accordingly.
func resume():
	game_state = GameState.PLAY
	$AudioPlayer.increase_music_volume()
	$Menus.hide_all()

# game_over ends Snake, opens the game's game-over menu, saves any new high-score and
# updates the game's state accordingly.
func game_over():
	
	# Update game state
	game_state = GameState.GAME_OVER
	$AudioPlayer.stop_music()
	$AudioPlayer.play_game_over()
	$Game.stop_ticker()
	
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
	if game_state == GameState.PLAY:
		$Game.move_snake()

# _on_snake_dead is triggered when the snake crashes into the wall or itself.
func _on_snake_dead():
	game_over()

# _on_snake_apple_eaten is triggered when the snake eats an apple in-game.
func _on_snake_apple_eaten():
	
	# Update score
	score += 1
	$Game.update_score(score)
	
	# Update high score if it's been beaten
	var special_sound:bool = false
	if score > save_data.high_score:
		
		if score == save_data.WORM_MODE_THRESHOLD && !save_data.worm_mode_unlocked:
			$Game.worm_mode_unlocked()
			special_sound = true
		elif score == save_data.high_score+1: 
			$Game.new_high_score()
			special_sound = true
		
		$Game.update_high_score(score)
	
	# Play the audio with a special sound if the high-score was beaten, or if WORM MODE
	# has just been unlocked.
	$AudioPlayer.play_apple_collect(special_sound)


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
	$Game.refresh_mode()


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
		GameState.PAUSE:
			$AudioPlayer.play_cancel()
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
	if game_state == GameState.PLAY:
		
		# Check if this is the first input direction
		if $Game.ticker_is_stopped():
			$Game.start_ticker()
			$AudioPlayer.play_music()
		
		# Turn the snake
		if $Game.turn(direction):
			$AudioPlayer.play_turn()
