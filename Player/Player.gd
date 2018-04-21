extends Node2D

signal action_done

enum DIRECTION {
	LEFT,
	RIGHT
}

var can_do_action = false
var moving = false
var origin = Vector2()
var current_position = Vector2()
export (float) var time_unit = .2
var SCALE = 30
var time_left_before_next_move = 0

func _ready():
	SCALE = get_parent().SCALE
	current_position = position / SCALE
	current_position.x = floor(current_position.x)
	current_position.y = floor(current_position.y)
	time_left_before_next_move = 0
	get_node("Tween").connect("tween_completed", self, "on_player_action_completed")
	moving = false

func _process(delta):
	if !moving and can_do_action:
		if (Input.is_action_pressed("ui_left")) && (current_position.x > 0):
			move_to(LEFT)
		if Input.is_action_pressed("ui_right") && (current_position.x < Consts.GRID_WIDTH):
			move_to(RIGHT)
	position = current_position * SCALE

func move_to(direction):
	moving = true
	var next_position = current_position + get_direction(direction)
	var tween = get_node("Tween")
	tween.interpolate_property(
				self, "current_position",
				current_position, next_position,
				time_unit, Tween.TRANS_LINEAR, 0)
	tween.start()

func on_player_action_completed(object, property):
	moving = false
	emit_signal("action_done")

func get_direction(direction):
	match direction:
		DIRECTION.LEFT: return Vector2(-1, 0)
		DIRECTION.RIGHT: return Vector2(1, 0)