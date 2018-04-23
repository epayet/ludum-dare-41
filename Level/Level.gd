extends Node

var next_spawn = 4

func _ready():
	pass

func get_tetromino():
	var grid_position = Vector2(randi() % Consts.GRID_WIDTH, 0)
	var tetromino = preload("res://Tetromino/Tetromino.tscn").instance()
	var type = tetromino.get_random_type()
	var weird_shape = []
	for i in range(5):
		for j in range(5):
			if randi() % 10 > 5:
				weird_shape.append(Vector2(i, j))
	var shape = tetromino.get_random_shape()
	tetromino.init(grid_position, weird_shape, Consts.WOOD_BLOCK)
	return tetromino
