extends KinematicBody2D

signal action_done
signal lives_updated(lives)

enum DIRECTION {
	LEFT,
	RIGHT
}

var aiming_visible = true
var bullet = preload("res://Weapons/Bullet/Bullet.tscn").instance()
var OFFSET = Vector2(Consts.GRID_CELL_SIZE/2, Consts.GRID_CELL_SIZE/2)
var origin = Vector2()
var grid_position = Vector2(floor(Consts.GRID_WIDTH / 2), Consts.GRID_HEIGHT - 1)
var lives = 1
var tween_position = Vector2()

export (float) var time_unit = .2

func _ready():
	get_node("Tween").connect("tween_completed", self, "on_player_action_completed")
	position = grid_position * Consts.GRID_CELL_SIZE + OFFSET
	tween_position = position

func move_to(direction):
	var next_grid_position = grid_position + direction
	if not within_bounds(next_grid_position):
		return false
	grid_position = next_grid_position
	var next_position = grid_position * Consts.GRID_CELL_SIZE + OFFSET
	var tween = get_node("Tween")
	$Sprite/AnimationPlayer.play("walk")
	tween.interpolate_property(
				self, "tween_position",
				position, next_position,
				time_unit, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	return tween.start()

func _process(delta):
	update_shooting_sight()

func _physics_process(delta):
	position = tween_position

func update_shooting_sight():
	var space_state = get_world_2d().direct_space_state
	var normal = (get_viewport().get_mouse_position() - position).normalized()
	var result = space_state.intersect_ray(position, position + normal * 1000, [self])
	if not result.empty():
		var target = result.position - position
		var rotation = atan2(target.y, target.x)
		$Kalash.flip_v = rotation < -( PI / 2 ) or rotation > PI / 2
		$Kalash.rotation = rotation
		$Aiming.points[1] = target

func add_lives(count):
	lives += count
	emit_signal("lives_updated", lives)
	
func rem_lives(count):
	lives-= count
	emit_signal("lives_updated", lives)

func within_bounds (position):
	return position.x >= 0 and position.y >= 0 and position.x < Consts.GRID_WIDTH and position.y < Consts.GRID_HEIGHT

func on_player_action_completed(object, property):
	$Sprite/AnimationPlayer.play("idle")
	emit_signal("action_done")

func set_aiming_visibility(visible):
	if visible:
		$Aiming.show()
	else:
		$Aiming.hide()
	aiming_visible = visible