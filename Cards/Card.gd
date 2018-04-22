extends Sprite

signal card_ended

const LAZER_CARD = 0
const LIFE_CARD = 1

var card_type
var world
var behaviour

func _ready():
	pass

func init(card_type):
	self.card_type = card_type
	$CardTypeSprite.frame = card_type

func get_behaviour(type, world):
	match card_type:
		LAZER_CARD: return LazerBehaviour.new(self, world)
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