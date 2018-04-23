extends Node

signal level_ended

var next_spawn = 4
var grid

func _ready():
	pass

func get_tetromino():
	var tetromino = preload("res://Tetromino/Tetromino.tscn").instance()
	var type = tetromino.get_random_type()
	var shape = tetromino.get_random_shape()
	grid.reset_grid_state()
	var grid_position = get_tetromino_shape_free_position(shape)
	if grid_position == null:
		return null
	tetromino.init(grid_position, shape, type)
	return tetromino

func get_tetromino_shape_free_position(shape, ttl=1000):
	if ttl == 0:
		return null
	var grid_position = Vector2(randi() % Consts.GRID_WIDTH, 0)
	if can_spawn_tetromino_at(shape, grid_position):
		return grid_position
	return get_tetromino_shape_free_position(shape, ttl - 1)

func can_spawn_tetromino_at(shape, position):
	for block_pos in shape:
		if not grid.is_position_free(block_pos + position):
			return false
	return true

func listen_end_of_level(node, function):
	emit_signal("level_ended", node, function)

func next_spawn_in():
	return randi() % 3 + 2