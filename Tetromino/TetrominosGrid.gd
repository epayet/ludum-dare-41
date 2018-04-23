extends Node2D

signal turn_done

var grid = []
var blocks = []
var pre_actions = []
enum State {
	IDLE,
	PRE_ACTION,
	POST_ACTION,
	MOVE_DOWN
}
var speed = 0.1
var state = State.IDLE

func _ready():
	reset_grid_state()
	pre_actions = []
	speed = 0.1
	pass

func _process(delta):
	match state:
		State.PRE_ACTION:
			if all_pre_actions_done():
				pre_actions = []
				post_actions()
		State.POST_ACTION:
			if all_post_actions_done():
				move_blocs_down()
		State.MOVE_DOWN:
			if all_tetrominos_moved():
				state = State.IDLE
				emit_signal("turn_done")
		_:	pass

func all_tetrominos_moved():
	for tetromino in get_children():
		if tetromino.is_moving:
			return false
	return true

func all_pre_actions_done ():
	for action in pre_actions:
		if not action.is_over():
			return false
	return true

func all_post_actions_done():
	return true

func reset_grid_state():
	grid.resize(Consts.GRID_WIDTH)
	for x in range(Consts.GRID_WIDTH):
		grid[x] = []
		grid[x].resize(Consts.GRID_HEIGHT)
		for y in range(Consts.GRID_HEIGHT):
			grid[x][y] = null
	for block in get_all_blocks():
		if within_bounds(block.grid_position):
			grid[block.grid_position.x][block.grid_position.y] = block
		else:
			block.queue_free()

func has_finished_turn():
	return true

func get_all_blocks():
	var blocks = []
	for tetromino in get_children():
		blocks += tetromino.get_blocks()
	return blocks

func get_block_from(grid_position):
	for block in blocks:
		if block.grid_position == grid_position:
			return block
	return null

func move(speed):
	self.speed = speed
	reset_grid_state()
	pre_actions()

func pre_actions():
	state = State.PRE_ACTION
	for action in pre_actions:
		action.execute(self, self.speed)

func post_actions():
	state = State.POST_ACTION
	var deleted_line = 0
	for i in range(Consts.GRID_HEIGHT):
		if is_line_complete(i):
			delete_line(i)

func move_blocs_down():
	state = State.MOVE_DOWN
	for tetromino in get_children():
		tetromino.move(self.speed)

func is_position_free(position):
	return within_bounds(position) and grid[position.x][position.y] == null
	
func can_move_block_from_to(block, position, same_tetromino = false):
	if not within_bounds(position):
		return false
	var block_at = grid[position.x][position.y]
	if block_at == null:
		return true
	return same_tetromino and block_at.get_parent() == block.get_parent()

func move_block_from_to(block, position, speed):
	grid[position.x][position.y] = block
	grid[block.grid_position.x][block.grid_position.y] = null
	block.next_move = position - block.grid_position
	block.move(speed)

func delete_line(line_number):
	for i in range(Consts.GRID_WIDTH):
		var block = grid[i][line_number]
		grid[i][line_number] = null
		if block:
			block.queue_free()

func is_line_complete(line_number):
	for i in range(Consts.GRID_WIDTH):
		if grid[i][line_number] == null:
			return false

func append_new_action (action):
	pre_actions.append(action)

func within_bounds (position):
	return position.x >= 0 and position.y >= 0 and position.x < Consts.GRID_WIDTH and position.y < Consts.GRID_HEIGHT
