extends Node2D

var grid = []
var blocks = []
var pre_actions = []
enum State {
	IDLE,
	PRE_ACTION,
	MOVE_DOWN
}
var state = State.IDLE

func _ready():
	reset_grid_state()
	pre_actions = []
	pass

func _process(delta):
	match state:
		State.PRE_ACTION:
			if all_pre_actions_done():
				pre_actions = []
				state = State.MOVE_DOWN
				move_blocs_down(0.1)
		_:	pass

func all_pre_actions_done ():
	for action in pre_actions:
		if not action.is_over():
			return false
	return true

func reset_grid_state():
	grid.resize(Consts.GRID_WIDTH)
	for x in range(Consts.GRID_WIDTH):
		grid[x] = []
		grid[x].resize(Consts.GRID_HEIGHT)
		for y in range(Consts.GRID_HEIGHT):
			grid[x][y] = null
	for block in get_all_blocks():
		grid[block.grid_position.x][block.grid_position.y] = block

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
	state = State.PRE_ACTION
	reset_grid_state()
	pre_move(speed)

func pre_move(speed):
	for action in pre_actions:
		action.execute(self, speed)

func move_blocs_down(speed):
	for tetromino in get_children():
		tetromino.move(speed)

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

func append_new_action (action):
	pre_actions.append(action)

func within_bounds (position):
	return position.x >= 0 and position.y >= 0 and position.x < Consts.GRID_WIDTH and position.y < Consts.GRID_HEIGHT
