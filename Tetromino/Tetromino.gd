extends Node2D

signal hit
var player
export (bool) var orientation = false

func _ready():
	pass

func tick():
	position.y += 30
	if position.y > get_viewport().size.y + 100:
		remove()

func _on_Area2D_area_entered(body):
	if body == player:
		print("encore mieux")

func remove():
	queue_free()
