extends Control

var AddScore = preload("res://GUI/AddScore.tscn")
var score = 0

func _ready():
	pass

func add_score(to_add):
	score += to_add
	
	var add_score = AddScore.instance()
	add_score.init(to_add)
	$ScoreModificationArea.add_child(add_score)
	$ScoreValue.text = str(score)

func set_lives(lives):
	$LivesValue.text = str(lives)
