extends Control

# max_num_digits defines the maximum number of digits that are displayable in both the
# score and the high-score HUD.
@export var max_num_digits:int = 3

# update_score updates the displayed current score in the HUD to the provided value.
func update_score(score: int):
	$Score.text = get_zeros(score) + str(score)

# update_high_score updates the displayed high-score in the HUD to the provided value.
func update_high_score(high_score: int):
	$HighScore.text = get_zeros(high_score) + str(high_score)

# get_zeros returns string of zeros that should be prepended to the provided score to
# ensure that the total number of digits displayed still equals max_num_digits.
func get_zeros(score:int) -> String:
	
	# Find the number of digits in the provided score
	var num_zeros:int = max_num_digits-num_digits(score)
	
	# Return a string of zeros to be prepended to that score
	var output:String = ""
	for x in num_zeros:
		output += "0"
	return output

# num_digits calculates and returns the number of digits in the provided integer n.
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
