extends Sprite

signal card_ended

const LAZER_CARD = 0
const LIFE_UP_CARD = 1
const BOX_SHOWER = 2
const LIFE_DOWN_CARD = 3

const CARD_TYPES = 4


var card_type
var world
var behaviour

func _ready():
	pass

func init(card_type):
	self.card_type = card_type
	$CardTypeSprite.frame = card_type

func get_random_type():
	return randi() % CARD_TYPES

func get_behaviour(type, world):
	match card_type:
		LAZER_CARD: return LazerBehaviour.new(self, world)
		LIFE_UP_CARD: return LifeBehaviour.new(self, world, 1)
		LIFE_DOWN_CARD: return LifeBehaviour.new(self, world, -1)
		BOX_SHOWER: return LazerBehaviour.new(self, world)
		_: print("No behaviour !")

func activate(world):
	behaviour = get_behaviour(card_type, world)
	behaviour.activate()

func player_moves():
	behaviour.player_moves()

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

	func player_moves():
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
		
	func player_moves():
		pass
	func player_fires():
		pass
	func turn_finished():
		var player = world.get_node("Player")
		if player.lives + amount > 0:
			player.add_lives(amount)
		parent.emit_signal("card_ended")
		parent.queue_free()