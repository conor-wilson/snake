extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func update_score(score: int):
	$Score.text = "Score: " + str(score)

func update_high_score(high_score: int):
	$HighScore.text = "High Score: " + str(high_score)

