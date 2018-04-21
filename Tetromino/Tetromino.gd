	extends Node2D

signal hit
signal moved

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

func _ready():
	#init(Vector2(2, 0), SHAPE_Z, null)
	#move(60)
	pass

func get_random_shape():
	return SHAPES[randi() % SHAPES.size()]

func init(grid_position, shape, player):
	self.player = player
	var block_scn = preload("res://Tetromino/Block.tscn")
	for pos in shape:
		var block = block_scn.instance()
		block.init(player, grid_position + pos)
		add_child(block)
		block.connect("moved", self, "block_moved")
		block.next_move = Vector2(0, 100)
	
func move(duration):
	for block in get_children():
		block.move(duration)
	is_moving = true

func block_moved():
	if is_moving and not has_children_moving():
		is_moving = false
		emit_signal("moved")
	if get_child_count() == 0:
		queue_free()

func has_children_moving():
	for block in get_children():
		if block.is_moving:
			return true
	return false
