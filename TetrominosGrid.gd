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
			grid[x][y] = get_block_from(Vector2(x, y))

func get_block_from(grid_position):
	for block in blocks:
		if block.grid_position == grid_position:
			return block
	return null

func move(speed):
	state = State.PRE_ACTION
	pre_move(speed)

func pre_move(speed):
	for action in pre_actions:
		action.execute()

func move_blocs_down(speed):
	for tetromino in get_children():
		tetromino.move(speed)

func _on_Bullet_hit_block(block, normal):
	pass
#	block.get_parent().action_on_block(block, normal)
func append_new_action (action):
	print(action)
	pre_actions.append(action)