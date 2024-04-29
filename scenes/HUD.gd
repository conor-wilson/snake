extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
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
	$StartButton.show()
	# Score behaviour
	$Score.hide()

func show_pause_menu():
	# Message behaviour
	$Message.text = "Paused"
	$Message.show()
	# Button behaviour
	$StartButton.text = "RESUME"
	$StartButton.show()
	# Score behaviour
	$Score.show()

func show_game_over_screen():
	# Message behaviour
	$Message.text = "Game Over"
	$Message.show()
	# Button behaviour
	$StartButton.text = "TRY AGAIN"
	$StartButton.show()
	# Score behaviour
	$Score.hide()

func show_in_game_hud():
	# Message behaviour
	$Message.hide()
	# Button behaviour
	$StartButton.hide()
	# Score behaviour
	$Score.show()

func _on_start_button_pressed():
	start_game.emit()
