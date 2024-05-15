extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func update_score(score: int):
	$Score.text = "Score: 00" + str(score)

func update_high_score(high_score: int):
	$HighScore.text = "High Score: 0" + str(high_score)

