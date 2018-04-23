extends Node

var cards = []
var Card = preload("res://Cards/Card.tscn")
var active_card

var card_cooldown_original = 5
var card_cooldown = card_cooldown_original

func _ready():
	$World/Player.connect("lives_updated", self, "set_lives")
	$World.connect("player_fires", self, "player_fires")
	$World.connect("turn_finished", self, "turn_finished")
	$World.connect("player_start_action", self, "player_start_move")
	set_lives($World/Player.lives)

func set_lives(count):
	$GUI.set_lives(count)
	if count <= 0:
		var loose = preload("res://GUI/Loose.tscn").instance()
		add_child(loose)
		$Music.stop()
	
func _on_World_add_score(amount):
	$GUI.add_score(amount)

func add_random_card():
	var card = build_random_card()
	cards.append(card)
	if not active_card:
		activate_next_card()

func build_random_card():
	var card = Card.instance()
	var type = card.get_random_type()
	card.init(type)
	return card

func activate_next_card():
	active_card = null
	if not cards.empty():
		var card = cards.pop_front()
		activate_card(card)

func activate_card(card):
	$Cards.add_child(card)
	active_card = card
	card.connect("card_ended", self, "activate_next_card")
	active_card.activate($World)
	
func player_fires():
	if active_card:
		active_card.player_fires()
func player_start_move():
	if active_card:
		active_card.player_start_move()

func turn_finished():
	$GUI.turn_finished()
	if active_card:
		active_card.turn_finished()
	card_cooldown -= 1
	if card_cooldown == 0:
		add_random_card()
		card_cooldown = randi() % card_cooldown_original + 2