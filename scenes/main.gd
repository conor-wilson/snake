extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.show_start_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# TODO: descriptor
func _on_snake_hit():
	$HUD.show_game_over_screen()
	$Snake.kill_snake()


func _on_hud_start_game():
	print("STARTING GAME!")
	$Snake.spawn_new_snake()
	$HUD.show_in_game_hud()


func _on_snake_pause():
	print("PAUSING")
