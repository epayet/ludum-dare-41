extends Node2D

signal hit
export (bool) var orientation = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func tick():
	position.y += 30

func _on_Area2D_area_entered(area):
	print(area.get_name())
	if area.get_name() == "player":
		print("oups")
		print("oups")
	print("collision")
