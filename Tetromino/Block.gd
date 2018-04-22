extends KinematicBody2D

const ROCK_BLOCK = 0
const WOOD_BLOCK = 1
const STEEL_BLOCK = 2
const OBSIDIAN_BLOCK = 3

var next_move
var is_moving = false
var block_type = ROCK_BLOCK

export (int) var speed = 1
export (Vector2) var grid_position = Vector2(0, 0)

var OFFSET = Vector2(Consts.GRID_CELL_SIZE/2, Consts.GRID_CELL_SIZE/2)
var tween_position = Vector2()

func _ready():
	$Tween.connect("tween_completed", self, "move_done")
	$Area2D.connect("body_entered", self, "body_entered_in_area")
	tween_position = position


func init(grid_position, block_type, speed = 1):
	self.grid_position = grid_position
	self.block_type = block_type
	position = grid_position * Consts.GRID_CELL_SIZE + OFFSET
	self.speed = speed
	$Sprite.frame = block_type

	reset_move()

func _physics_process(delta):
	position = tween_position

func reset_move():
	next_move = Vector2(0, speed)

func move(duration):
	is_moving = true
	grid_position = grid_position + next_move
	$Tween.interpolate_property(
				self, "tween_position",
				position, grid_position * Consts.GRID_CELL_SIZE + OFFSET,
				duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func move_done(object, key):
	is_moving = false
	reset_move()
	
	if position.y > get_viewport().size.y + Consts.GRID_CELL_SIZE:
		queue_free()

func hit_by_bullet (bullet, normal):
	get_parent().update_moves(bullet, self, normal)
	
func body_entered_in_area(object):
	if object.is_in_group("player"):
		object.rem_lives(1)
		get_parent().queue_free()
