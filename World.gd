extends Node

var Bullet = load("res://Bullet/Bullet.tscn")
export (int) var grid_width = 10
export (int) var grid_height = 15
export (PackedScene) var tetrominos
export (int) var spawn_rate = 5
export (int) var next_spawn = 0
export (int) var SCALE = 30

func _ready():
	next_spawn = 0
	
	pass

func _process(delta):
	randomize()
	$ShootingSight.points[0] = $Player.position

	
func spawn_new_tetromino():
	next_spawn = spawn_rate
	var tetromino = random_tetromino()
	tetromino.position.x = (randi() % grid_width) * 10
	tetromino.position.y = -100
	tetromino.player = $Player
	$Tetrominos.add_child(tetromino)

func random_tetromino():
	var tetrominos = ["L", "J", "I", "S", "Square", "T", "Z"]
	var tetromino_type = tetrominos[randi() % tetrominos.size()]
	return load("res://Tetromino/Tetromino" + tetromino_type + ".tscn").instance()

func _input(event):
   if event is InputEventMouseButton:
	   add_bullet(event.position)
   elif event is InputEventMouseMotion: 
	   update_sight_shooting(event.position)
		
func add_bullet(target):
	var bullet = Bullet.instance()
	bullet.position = $Player.position
	var direction = (target - $Player.position).normalized()
	self.add_child(bullet)
	
	
func update_sight_shooting(target):
	var playerPosition = $Player.position
	var endPosition = (target - playerPosition).normalized() * 1000
	endPosition += playerPosition
	$ShootingSight.points[1] = endPosition
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(playerPosition, endPosition, [$Player.get_node("Area2D")])
	if result:
	   pass

func tick():
	for tetromino in $Tetrominos.get_children():
		tetromino.tick()

func _on_Player_action_done():
	next_spawn -= 1
	if next_spawn <= 0:
		spawn_new_tetromino()
	tick()
