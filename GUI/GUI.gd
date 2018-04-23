extends Control

var AddScore = preload("res://GUI/AddScore.tscn")
var score = 0
var turn_score = 0

func _ready():
	pass

func add_score(to_add):
	score += to_add
	turn_score += to_add

func set_lives(lives):
	$LivesValue.text = str(lives)

func turn_finished():
	if turn_score != 0:
		var add_score = AddScore.instance()
		add_score.init(turn_score)
		$ScoreModificationArea.add_child(add_score)
		turn_score = 0
		$ScoreValue.text = str(score)