extends Node

var L = load("res://Tetromino/TetrominoL.tscn")

export (int) var grid_width = 10
export (int) var grid_height = 15
export (PackedScene) var tetrominos
export (int) var spawn_rate = 5
export (int) var next_spawn = 0

func _ready():
	next_spawn = 0
	
	pass

func _process(delta):
	randomize()
	pass

func _on_Player_move():
	next_spawn -= 1
	if next_spawn <= 0:
		spawn_new_tetromino()
	tick()
	
func spawn_new_tetromino():
	next_spawn = spawn_rate
	var tetromino = random_tetromino()
	tetromino.position.x = (randi() % grid_width) * 10
	tetromino.position.y = -100
	$Tetrominos.add_child(tetromino)

func random_tetromino():
	var tetrominos = ["L", "J", "I", "S", "Square", "T", "Z"]
	var tetromino_type = tetrominos[randi() % tetrominos.size()]
	return load("res://Tetromino/Tetromino" + tetromino_type + ".tscn").instance()

func tick():
	for tetromino in $Tetrominos.get_children():
		tetromino.tick()
	pass
