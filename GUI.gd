extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var score = 0

func _ready():
	pass

func add_score(to_add):
	score += to_add
	$ScoreValue.text = str(score)

func set_lives(lives):
	$LivesValue.text = str(lives)