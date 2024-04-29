extends CanvasLayer

signal start_game

var default_button_pos : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	
	default_button_pos = $StartButton.get_position()
	
	$StartButton.hide()
	$Message.hide()
	$Score.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_start_menu():
	# Message behaviour
	$Message.text = "Welcome to Snake!"
	$Message.show()
	# Button behaviour
	$StartButton.text = "START GAME"
	$StartButton.set_position(default_button_pos)
	$StartButton.show()
	# Score behaviour
	$Score.hide()

func show_pause_menu():
	# Message behaviour
	$Message.text = "Paused"
	$Message.show()
	# Button behaviour
	$StartButton.text = "RESUME"
	$StartButton.set_position(default_button_pos)
	$StartButton.show()
	# Score behaviour
	$Score.show()

func show_game_over_screen(score: int):
	# Message behaviour
	$Message.text = "Game Over\nScore: " + str(score)
	$Message.show()
	# Button behaviour
	$StartButton.text = "TRY AGAIN"
	$StartButton.set_position(default_button_pos + Vector2i(0, 32))
	$StartButton.show()
	# Score behaviour
	$Score.show()

func show_in_game_hud():
	# Message behaviour
	$Message.hide()
	# Button behaviour
	$StartButton.hide()
	# Score behaviour
	$Score.show()

func update_score(score: int):
	$Score.text = "Score: " + str(score)

func _on_start_button_pressed():
	start_game.emit()
