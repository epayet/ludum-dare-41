extends Node

signal level_ended

var next_spawn = 4

func _ready():
	pass

func get_tetromino():
	var grid_position = Vector2(randi() % Consts.GRID_WIDTH, 0)
	var tetromino = preload("res://Tetromino/Tetromino.tscn").instance()
	var type = tetromino.get_random_type()
	var shape = tetromino.get_random_shape()
	tetromino.init(grid_position, shape, type)
	return tetromino

func listen_end_of_level(node, function):
	emit_signal("level_ended", node, function)

func next_spawn_in():
	return randi() % 3 + 2