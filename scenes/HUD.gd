extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.hide()
	$Message.hide()

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

func show_game_over_screen():
	# Message behaviour
	$Message.text = "Game Over"
	$Message.show()
	# Button behaviour
	$StartButton.text = "TRY AGAIN"
	$StartButton.show()
	
func show_in_game_hud():
	# Message behaviour
	$Message.hide()
	# Button behaviour
	$StartButton.hide()

func _on_start_button_pressed():
	start_game.emit()
