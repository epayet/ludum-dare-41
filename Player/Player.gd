extends Node2D

signal tick

var origin = Vector2()
var grid_position = Vector2()
var current_position = Vector2()
var next_position = Vector2()
export (float) var time_unit = .2
export (int) var SCALE = 30
var time_left_before_next_move = 0

func _ready():
	origin = position
	time_left_before_next_move = 0
	pass

func _process(delta):
	# use Tween
	if time_left_before_next_move > 0:
		time_left_before_next_move -= delta
		update_player_position()
	else:
		if Input.is_action_pressed("ui_left"):
			set_next_position(-1)
			emit_signal("tick")
		if Input.is_action_pressed("ui_right"):
			set_next_position(1)
			emit_signal("tick")
	position = origin + grid_position * SCALE

func set_next_position (amount):
	current_position = grid_position
	next_position = current_position
	next_position.x += amount
	time_left_before_next_move = time_unit
	
func update_player_position():
	if time_left_before_next_move <= 0:
		time_left_before_next_move = 0
		grid_position = next_position
	else:
		var diff = next_position - current_position
		var progress = (time_unit - time_left_before_next_move) / time_unit
		grid_position = current_position + diff * progress