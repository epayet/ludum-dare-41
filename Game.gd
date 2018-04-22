extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$World/Player.connect("lives_updated", self, "set_lives")
	set_lives($World/Player.lives)

func set_lives(count):
	$GUI.set_lives(count)
	
func _on_World_add_score(amount):
	$GUI.add_score(amount)
