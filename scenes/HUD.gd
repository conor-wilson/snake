extends Control

@export var max_num_digits:int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func update_score(score: int):
	$Score.text = get_zeros(score) + str(score)

func update_high_score(high_score: int):
	$HighScore.text = get_zeros(high_score) + str(high_score)


# TODO: Descriptor
func get_zeros(score:int) -> String:
	# Find the number of digits in the provided score
	var num_zeros:int = max_num_digits-num_digits(score)
	
	# Return a string of zeros to be prepended to that score
	var output:String = ""
	for x in num_zeros:
		output += "0"
	return output

# TODO: Descriptor
func num_digits(n:int) -> int :
	
	# If the provided number is 0, it's one digit long
	if n == 0:
		return 1
	
	# Otherwise, calculate the number of digits and return
	var digits:int = 0
	while n!=0:
		n /= 10
		digits += 1
	return digits
