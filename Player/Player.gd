extends Node2D

signal action_done

enum DIRECTION {
	LEFT,
	RIGHT
}

var OFFSET = Vector2(Consts.GRID_CELL_SIZE/2, Consts.GRID_CELL_SIZE/2)
var origin = Vector2()
var grid_position = Vector2(floor(Consts.GRID_WIDTH / 2), Consts.GRID_HEIGHT - 1)
export (float) var time_unit = .2

func _ready():
	get_node("Tween").connect("tween_completed", self, "on_player_action_completed")
	position = grid_position * Consts.GRID_CELL_SIZE + OFFSET

func _process(delta):
	pass

func move_to(direction):
	var next_grid_position = grid_position + direction
	if not within_bounds(next_grid_position):
		return false
	grid_position = next_grid_position
	var next_position = grid_position * Consts.GRID_CELL_SIZE + OFFSET
	var tween = get_node("Tween")
	tween.interpolate_property(
				self, "position",
				position, next_position,
				time_unit, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	return tween.start()
	
func within_bounds (position):
	return position.x >= 0 and position.y >= 0 and position.x < Consts.GRID_WIDTH and position.y < Consts.GRID_HEIGHT

func on_player_action_completed(object, property):
	emit_signal("action_done")
