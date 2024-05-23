extends Button

var unchecked_icon = preload("res://art/checkBoxUnchecked.png")
var checked_icon = preload("res://art/checkBoxChecked.png")

func set_icon(checked:bool):
	if checked:
		icon = checked_icon
	else:
		icon = unchecked_icon
