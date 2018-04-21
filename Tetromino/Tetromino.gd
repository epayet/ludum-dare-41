extends Node2D

signal hit
export (bool) var orientation = false

func _ready():
	pass

func tick():
	position.y += 30
	if position.y > get_viewport().size.y + 100:
		remove()

func _on_Area2D_area_entered(area):
	print(area.get_name())
	if area.get_name() == "player":
		print("oups")
	print("collision")

func remove():
	queue_free()
