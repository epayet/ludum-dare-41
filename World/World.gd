extends Node

signal add_score(amount)
signal player_fires
signal turn_finished
signal player_start_action

var state = WAITING_PLAYER_ACTION
var Bullet = load("res://Weapons/Bullet/Bullet.tscn")
var Lazer = preload("res://Weapons/Lazer/Lazer.tscn")
export (PackedScene) var tetrominos
export (int) var spawn_rate = 5
export (int) var next_spawn = 0
export (int) var SCALE = 30
export (int) var speed = 0.2
var weapon = Consts.Weapon.DEFAULT

var level = preload("res://Level/Level.tscn").instance()

enum State {
	WAITING_PLAYER_ACTION,
	MOVING_TETROMINOS,
	PLAYER_IN_ACTION
}

func _ready():
	next_spawn = 0
	level.grid = $Tetrominos
	randomize()
	set_state(State.WAITING_PLAYER_ACTION)

func _process(delta):
	match state:
		State.WAITING_PLAYER_ACTION:
			if Input.is_action_pressed("ui_left"):
				if $Tetrominos.is_position_free($Player.grid_position + Consts.LEFT) and $Player.move_to(Consts.LEFT):
					set_state(State.PLAYER_IN_ACTION)
			if Input.is_action_pressed("ui_right"):
				if $Tetrominos.is_position_free($Player.grid_position + Consts.RIGHT) and $Player.move_to(Consts.RIGHT):
					set_state(State.PLAYER_IN_ACTION)
			elif Input.is_mouse_button_pressed(BUTTON_LEFT):
				fire(get_viewport().get_mouse_position())
				set_state(State.PLAYER_IN_ACTION)
		_:
			pass

func spawn_new_tetromino():
	next_spawn = level.next_spawn_in()
	var tetromino = level.get_tetromino()
	for block in tetromino.get_blocks():
		block.connect("block_destroyed_by_player", self, "_on_block_destroyed")
	$Tetrominos.add_child(tetromino)

func fire(mouse_position):
	match weapon:
		Consts.Weapon.DEFAULT: add_bullet(mouse_position)
		Consts.Weapon.LAZER: add_lazer(mouse_position)
	
func add_bullet(mouse_position):
	var target = _get_nearest_node(mouse_position)
	if target:
		var bullet = Bullet.instance()
		bullet.connect("action_done", self, "_on_Bullet_action_done")
		var direction = (mouse_position - $Player.position).normalized()
		bullet.position = $Player.position + direction * Consts.GRID_HALF_CELL_SIZE
		bullet.apply_impulse(Vector2(), direction * Consts.BULLET_SPEED)
		set_state(State.MOVING_TETROMINOS)
		add_child(bullet)
		emit_signal("player_fires")

func add_lazer(mouse_position):
	var target = _get_nearest_node(mouse_position)
	if target:
		var lazer = Lazer.instance()
		lazer.position = $Player.position
		lazer.connect("action_done", self, "action_done")
		var rotation = -($Player.position - mouse_position).angle_to(Vector2(0, 1))
		lazer.rotation = rotation
		set_state(State.MOVING_TETROMINOS)
		add_child(lazer)
		emit_signal("player_fires")

func action_done():
	next_spawn -= 1
	if next_spawn <= 0:
		spawn_new_tetromino()
	move_tetrominos()
	emit_signal("add_score", 1)

func move_tetrominos():
	set_state(State.MOVING_TETROMINOS)
	$Tetrominos.move(speed)

func set_state(new_state):
	state = new_state
	if state == State.PLAYER_IN_ACTION:
		emit_signal("player_start_action")

func _get_nearest_node(mouse_position):
	var space_state = get_world_2d().direct_space_state
	var endPosition = (mouse_position - $Player.position).normalized() * 1000
	endPosition += $Player.position
	return space_state.intersect_ray($Player.position, endPosition, [$Player])

func spawn_explosion_at(grid_position):
	var explosion = preload("res://Tetromino/Effects/Explosion.tscn").instance()
	explosion.position = grid_position * Consts.GRID_CELL_SIZE
	explosion.position.x += Consts.GRID_HALF_CELL_SIZE
	explosion.position.y += Consts.GRID_HALF_CELL_SIZE
	add_child(explosion)
	explosion.play()
	$Explosion.play()
	
# SIGNAL'S CALLBACKS

func _on_Area2D_area_exited(area):
	area.queue_free()

func _on_Tetrominos_turn_done():
	set_state(State.WAITING_PLAYER_ACTION)
	emit_signal("turn_finished")

func _on_Player_action_done():
	action_done()
	
func _on_Bullet_action_done():
	action_done()

func _on_block_destroyed(position):
	emit_signal("add_score", 1)
	spawn_explosion_at(position)

