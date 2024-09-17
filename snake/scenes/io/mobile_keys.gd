extends Node2D

signal up
signal down
signal left
signal right

func _on_up_button_down() -> void:
	up.emit()

func _on_down_button_down() -> void:
	down.emit()

func _on_left_button_down() -> void:
	left.emit()

func _on_right_button_down() -> void:
	right.emit()
