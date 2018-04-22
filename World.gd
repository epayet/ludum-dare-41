extends Node

signal add_score(amount)

var state = WAITING_PLAYER_ACTION
var Bullet = load("res://Bullet/Bullet.tscn")
export (PackedScene) var tetrominos
export (int) var spawn_rate = 5
export (int) var next_spawn = 0
export (int) var SCALE = 30
export (int) var speed = 0.5

enum State {
	WAITING_PLAYER_ACTION,
	MOVING_TETROMINOS,
	PLAYER_IN_ACTION
}

func _ready():
	next_spawn = 0
	randomize()
	set_state(State.WAITING_PLAYER_ACTION)

func _process(delta):
	$ShootingSight.points[0] = $Player.position	
	update_state()
	update_sight_shooting()
	match state:
		State.WAITING_PLAYER_ACTION:
			if Input.is_action_pressed("ui_left"):
				if $Player.move_to(Consts.LEFT):
					set_state(State.PLAYER_IN_ACTION)
			if Input.is_action_pressed("ui_right"):
				if $Player.move_to(Consts.RIGHT):
					set_state(State.PLAYER_IN_ACTION)
			elif Input.is_mouse_button_pressed(BUTTON_LEFT):
				add_bullet(get_viewport().get_mouse_position())
				set_state(State.PLAYER_IN_ACTION)
		_:
			pass

func update_state():
	if state == State.MOVING_TETROMINOS and all_tetrominos_moved():
		set_state(State.WAITING_PLAYER_ACTION)

func spawn_new_tetromino():
	next_spawn = spawn_rate
	var tetromino = random_tetromino_at(Vector2(randi() % Consts.GRID_WIDTH, 0))
	$Tetrominos.add_child(tetromino)

func random_tetromino_at(grid_position):
	var tetrominos = preload("res://Tetromino/Tetromino.tscn").instance()
	tetrominos.init(grid_position, tetrominos.get_random_shape(), $Player)
	return tetrominos

func add_bullet(mouse_position):
	var target = _get_nearest_node(mouse_position)
	if target:
		var bullet = Bullet.instance()
		bullet.connect("action_done", self, "_on_Bullet_action_done")
		bullet.position = $Player.position
		bullet.set_target_position(target.position)
		set_state(State.MOVING_TETROMINOS)
		add_child(bullet)

func update_sight_shooting():
	var target = get_viewport().get_mouse_position()
	var playerPosition = $Player.position
	var endPosition = (target - playerPosition).normalized() * 1000
	endPosition += playerPosition
	$ShootingSight.points[1] = endPosition

func action_done():
	next_spawn -= 1
	if next_spawn <= 0:
		spawn_new_tetromino()
	move_tetrominos()
	emit_signal("add_score", 1)

func _on_Player_action_done():
	action_done()
	
func _on_Bullet_action_done():
	action_done()
	
func move_tetrominos():
	set_state(State.MOVING_TETROMINOS)
	for tetromino in $Tetrominos.get_children():
		tetromino.move(speed)

func set_state(new_state):
	state = new_state
		
func all_tetrominos_moved():
	for tetromino in $Tetrominos.get_children():
		if tetromino.is_moving:
			return false
	return true

func _get_nearest_node(mouse_position):
	var space_state = get_world_2d().direct_space_state
	var endPosition = (mouse_position - $Player.position).normalized() * 1000
	endPosition += $Player.position
	return space_state.intersect_ray($Player.position, endPosition, [$Player])


func _on_Area2D_area_exited(area):
	area.queue_free()
	pass # replace with function body
