extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var score = 0

func _ready():
	$ScoreModificationArea/PlusOne/PlusOneAnimation.connect(
		"animation_finished", self, "_score_animation_finished"
	)

func add_score(to_add):
	score += to_add
	$ScoreModificationArea/PlusOne.show()
	$ScoreModificationArea/PlusOne/PlusOneAnimation.play('score')
	$ScoreValue.text = str(score)

func set_lives(lives):
	$LivesValue.text = str(lives)
	
func _score_animation_finished(thing):
	$ScoreModificationArea/PlusOne.hide()