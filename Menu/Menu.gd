extends Node

func _ready():
	$MainMenu/content/CreditButton.connect("pressed", self, "show_credits")
	$MainMenu/content/RulesButton.connect("pressed", self, "show_rules")
	$Credits/BackToMenu.connect("pressed", self, "show_menu")
	$Rules/BackToMenu.connect("pressed", self, "show_menu")
	$MainMenu/content/PlayButton.connect("pressed", self , "play")
	
	$MainMenu/anim.play("Start")
	$MainMenu/anim.connect("animation_finished", self, "anim_finished")

func show_credits():
	$Credits.visible = true

func show_menu():
	$Credits.visible = false
	$Rules.visible = false
	
func show_rules():
	$Rules.visible = true
	
func play():
	$MainMenu/anim.play("Play")

func anim_finished(anim_name):
	if anim_name == "Play":
		get_tree().change_scene("res://Game.tscn")