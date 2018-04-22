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

func execute_action (action):
	print("execute_action")
	pass

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
	var action = {
		'block': block,
		'direction': normal * -1
	}
	get_parent().append_new_action(action)
