extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.hide()
	$DeathMessage.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_start_menu():
	$StartButton.show()
	$DeathMessage.hide()

func show_game_over_screen():
	$StartButton.hide()
	$DeathMessage.show()
	
func show_in_game_hud():
	$StartButton.hide()
	$DeathMessage.hide()

func _on_start_button_pressed():
	start_game.emit()
