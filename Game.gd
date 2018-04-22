extends Node

func _ready():
	$World/Player.connect("lives_updated", self, "set_lives")
	set_lives($World/Player.lives)

func set_lives(count):
	$GUI.set_lives(count)
	if count <= 0:
		var loose = preload("res://GUI/Loose.tscn").instance()
		add_child(loose)
	
func _on_World_add_score(amount):
	$GUI.add_score(amount)
