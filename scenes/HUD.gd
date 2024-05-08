extends CanvasLayer

signal start_game # TODO: Rename this to "play"
signal options
signal quit
signal main_menu

var default_button_pos : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	
	default_button_pos = $StartButton.get_position()
	
	$StartButton.hide()
	$Message.hide()
	$Score.hide()
	$HighScore.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_all():
	$MainMenu.hide()
	$PauseMenu.hide()
	$GameOverMenu.hide()

func show_start_menu():
	hide_all()
	$MainMenu.show_and_focus()
	
	# Message behaviour
	$Message.hide()
	# Button behaviour
	$StartButton.hide()
	# Score behaviour
	$Score.hide()
	$HighScore.hide()

func show_pause_menu():
	hide_all()
	$PauseMenu.show_and_focus()
	
	# Message behaviour
	$Message.hide()
	# Button behaviour
	$StartButton.hide()
	# Score behaviour
	$Score.show()
	$HighScore.show()

func show_game_over_screen(score: int):
	hide_all()
	$GameOverMenu.show_and_focus()
	
	# Message behaviour
	$Message.hide()
	# Button behaviour
	$StartButton.hide()
	# Score behaviour
	$Score.show()
	$HighScore.show()

func show_in_game_hud():
	hide_all()
	
	# Message behaviour
	$Message.hide()
	# Button behaviour
	$StartButton.hide()
	# Score behaviour
	$Score.show()
	$HighScore.show()

func update_score(score: int):
	$Score.text = "Score: " + str(score)

func update_high_score(high_score: int):
	$HighScore.text = "High Score: " + str(high_score)

func _on_start_button_pressed():
	start_game.emit()


func _on_main_menu_start_game():
	start_game.emit()

func _on_main_menu_options_menu():
	options.emit()

func _on_main_menu_quit():
	quit.emit()


func _on_pause_menu_resume():
	start_game.emit()

func _on_pause_menu_options():
	options.emit()

func _on_pause_menu_quit_to_main():
	main_menu.emit()


func _on_game_over_menu_try_again():
	start_game.emit()

func _on_game_over_menu_main_menu():
	main_menu.emit()

