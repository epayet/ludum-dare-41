extends Node2D

signal hit

var player
var is_moving
export (bool) var orientation = false
var shape

const SHAPE_I = [Vector2(0, 0), Vector2(0, 1), Vector2(0, 2), Vector2(0, 3)]
const SHAPE_L = [Vector2(0, 0), Vector2(0, 1), Vector2(0, 2), Vector2(1, 2)]
const SHAPE_J = [Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(0, 2)]
const SHAPE_T = [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(1, 1), Vector2(1, 2)]
const SHAPE_S = [Vector2(1, 0), Vector2(2, 0), Vector2(0, 1), Vector2(1, 1)]
const SHAPE_Z = [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)]
const SHAPE_SQUARE = [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]

const SHAPES = [SHAPE_I, SHAPE_L, SHAPE_J, SHAPE_T, SHAPE_S, SHAPE_S, SHAPE_Z, SHAPE_SQUARE]

func _process(delta):
	if is_moving and not has_children_moving():
		is_moving = false
	if get_child_count() == 0:
		if is_moving:
			is_moving = false
		queue_free()

func get_random_shape():
	return SHAPES[randi() % SHAPES.size()]

func get_blocks():
	return get_children()

func compute_shape_dimensions(shape):
	var dim = Vector2(0, 0)
	for block in shape:
		dim.x = max(dim.x, block.x)
		dim.y = max(dim.y, block.y)
	return dim

func init(grid_position, shape):
	var block_scn = preload("res://Tetromino/Block.tscn")
	var dim = compute_shape_dimensions(shape)
	grid_position.x = min(grid_position.x, Consts.GRID_WIDTH - dim.x - 1)

	for pos in shape:
		var block = block_scn.instance()
		block.init(grid_position + pos, Consts.ROCK_BLOCK)
		add_child(block)

func move(duration):
	for block in get_children():
		block.move(duration)
	is_moving = true

func has_children_moving():
	for block in get_children():
		if block.is_moving:
			return true
	return false

func block_has_been_hit (bullet, block, normal):
	var action = null
	var direction = get_direction_from_normal(normal)
	match block.block_type:
		Consts.WOOD_BLOCK:
			action = DestroyBlockAction.new(block)
		Consts.STEEL_BLOCK:
			action = PreMoveTetrominoAction.new(block, direction)
		Consts.ROCK_BLOCK:
			action = PreMoveBlockAction.new(block, direction)
		_:	pass
	if action:
		get_parent().append_new_action(action)

func get_direction_from_normal(normal):
	var x = abs(normal.x)
	var y = abs(normal.y)
	if x != 1 and y != 1:
		if x < y:
			return Vector2(0, y).normalized() * -1
		return Vector2(x, 0).normalized() * -1
	return normal * -1

class PreMoveBlockAction:
	var block
	var direction

	func _init(block, direction):
		self.block = block
		self.direction = direction

	func execute(grid, speed):
		var new_grid_position = block.grid_position + direction
		if grid.can_move_block_from_to(block, new_grid_position):
			grid.move_block_from_to(block, new_grid_position, speed)

	func is_over():
		return not block.is_moving

class PreMoveTetrominoAction:
	var tetromino
	var direction

	func _init(block, direction):
		self.tetromino = block.get_parent()
		self.direction = direction

	func can_move_tetromino(grid):
		for block in tetromino.get_blocks():
			if not grid.can_move_block_from_to(block, block.grid_position + direction, true):
				return false
		return true

	func move_tetromino(grid, speed):
		for block in tetromino.get_blocks():
			grid.move_block_from_to(block, block.grid_position + direction, speed)

	func execute(grid, speed):
		if can_move_tetromino(grid):
			move_tetromino(grid, speed)

	func is_over():
		return not tetromino.is_moving

class DestroyBlockAction:
	var block
	var over = false

	func _init(block):
		self.block = block

	func execute(grid, speed):
		block.queue_free()
		over = true

	func is_over():
		return over

