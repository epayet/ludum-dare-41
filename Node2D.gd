extends "res://Tetromino/Tetromino.gd"

signal hit
export (bool) var orientation = false

func _ready():
	pass

func _on_Block1_area_entered(area):
	pass # replace with function body

func _on_Area2D_area_entered(area):
	print(area.get_name())
	if area.get_name() == "player":
		print("oups")
		print("oups")
	print("collision")
