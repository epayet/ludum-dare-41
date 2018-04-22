extends Node2D

signal action_done

enum DIRECTION {
	LEFT,
	RIGHT
}

var OFFSET = Vector2(Consts.GRID_CELL_SIZE/2, Consts.GRID_CELL_SIZE/2)
var can_do_action = false
var moving = false
var origin = Vector2()
var grid_position = Vector2(floor(Consts.GRID_WIDTH / 2), Consts.GRID_HEIGHT - 1)
export (float) var time_unit = .2

func _ready():
	get_node("Tween").connect("tween_completed", self, "on_player_action_completed")
	moving = false

func _process(delta):
	if !moving: 
		position = grid_position * Consts.GRID_CELL_SIZE + OFFSET
		if can_do_action:
			if (Input.is_action_pressed("ui_left")) && (grid_position.x > 0):
				move_to(LEFT)
			if Input.is_action_pressed("ui_right") && (grid_position.x < Consts.GRID_WIDTH - 1):
				move_to(RIGHT)

func move_to(direction):
	moving = true
	grid_position = grid_position + get_direction(direction)
	var next_position = grid_position * Consts.GRID_CELL_SIZE + OFFSET
	var tween = get_node("Tween")
	tween.interpolate_property(
				self, "position",
				position, next_position,
				time_unit, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func on_player_action_completed(object, property):
	moving = false
	emit_signal("action_done")

func get_direction(direction):
	match direction:
		DIRECTION.LEFT: return Vector2(-1, 0)
		DIRECTION.RIGHT: return Vector2(1, 0)
