extends Node

export (int) var grid_width = 10
export (int) var grid_height = 15
export (PackedScene) var tetrominos

func _ready():
	pass

func _process(delta):
	pass

func _on_Player_move():
	tick()

func tick():
	for tetromino in $Tetrominos.get_children():
		tetromino.tick()
	pass
