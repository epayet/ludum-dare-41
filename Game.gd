extends Node

var score = 0
var cards = []
var Card = preload("res://Cards/Card.tscn")
var active_card

func _ready():
	$World/Player.connect("lives_updated", self, "set_lives")
	$World.connect("player_fires", self, "player_fires")
	$World.connect("turn_finished", self, "turn_finished")
	set_lives($World/Player.lives)

func set_lives(count):
	$GUI.set_lives(count)
	if count <= 0:
		var loose = preload("res://GUI/Loose.tscn").instance()
		add_child(loose)
	
func _on_World_add_score(amount):
	$GUI.add_score(amount)
	score += amount
	
	if score % 5 == 0:
		add_random_card()

func add_random_card():
	var card = build_random_card()
	cards.append(card)
	if not active_card:
		activate_next_card()

func build_random_card():
	var card = Card.instance()
	card.init(0)
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

func turn_finished():
	if active_card:
		active_card.turn_finished()