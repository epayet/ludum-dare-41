extends Sprite

signal card_ended

const LAZER_CARD = 0
const LIFE_UP_CARD = 1
const BOX_SHOWER = 2
const LIFE_DOWN_CARD = 3
const LIMITED_ACTION_TIME = 4

const CARD_TYPES = 5


var card_type
var world
var behaviour

func _ready():
	pass

func init(card_type):
	self.card_type = card_type
	$CardTypeSprite.frame = card_type
	$Panel/Label.set_text(get_description(card_type))

func get_description(card_type):
	match card_type:
		LAZER_CARD: return "Pew pew!"
		LIFE_UP_CARD: return "From an\nitalian plumber\n\nwith love"
		LIFE_DOWN_CARD: return "Yeah...\nnot my best spell"
		BOX_SHOWER: return "They come\nin golden as well"
		LIMITED_ACTION_TIME: return "Maybe time's\njust a construct\nof human perception\nAn illusion\ncreated by..."
		_: "I don't know\nwhat I am\nplease be gentle"

func get_random_type():
	return randi() % CARD_TYPES

func get_behaviour(type, world):
	match card_type:
		LAZER_CARD: return LazerBehaviour.new(self, world)
		LIFE_UP_CARD: return LifeBehaviour.new(self, world, 1)
		LIFE_DOWN_CARD: return LifeBehaviour.new(self, world, -1)
		BOX_SHOWER: return LazerBehaviour.new(self, world)
		LIMITED_ACTION_TIME: return LimitedActionTime.new(self, world)
		_: print("No behaviour !")

func activate(world):
	behaviour = get_behaviour(card_type, world)
	behaviour.activate()

func player_start_move():
	behaviour.player_start_move()

func player_fires():
	behaviour.player_fires()

func turn_finished():
	behaviour.turn_finished()


class LazerBehaviour:
	var world
	var parent
	var used = false
	func _init(parent, world):
		self.parent = parent
		self.world = world
	func activate():
		world.weapon = Consts.Weapon.LAZER

	func player_start_move():
		pass

	func player_fires():
		world.weapon = Consts.Weapon.DEFAULT
		used = true

	func turn_finished():
		if used:
			parent.emit_signal("card_ended")
			parent.queue_free()

class LifeBehaviour:
	var world
	var parent
	var amount
	func _init(parent, world, amount):
		self.parent = parent
		self.world = world
		self.amount = amount

	func activate():
		pass
		
	func player_start_move():
		pass
	func player_fires():
		pass
	func turn_finished():
		var player = world.get_node("Player")
		if player.lives + amount > 0:
			player.add_lives(amount)
		parent.emit_signal("card_ended")
		parent.queue_free()

class LimitedActionTime:
	var world
	var parent
	var used = false
	var timer
	var ttl

	func _init(parent, world):
		ttl = 10
		self.parent = parent
		self.world = world
		timer = Timer.new()
		timer.connect("timeout", self, "timeout")
		parent.add_child(timer)

	func activate():
		pass

	func player_start_move():
		timer.stop()
	
	func timeout():
		world.action_done()

	func player_fires():
		pass

	func turn_finished():
		timer.wait_time = 0.5
		timer.start()
		ttl -= 1
		if ttl == 0:
			parent.emit_signal("card_ended")
			parent.queue_free()