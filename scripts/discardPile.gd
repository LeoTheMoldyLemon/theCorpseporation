extends Node3D

class_name DiscardPile

static var instance: DiscardPile;
func _init():
	DiscardPile.instance = self

var cards: Array = []

func empty():
	cards = []
	
func add_card(card:Card):
	cards.push_back(card)
	card.smooth_move(Transform3D(transform), 0.2)
	
func reshuffle():
	cards.shuffle()
	for card in cards:
		DrawPile.instance.add_card(card)
		await get_tree().create_timer(0.1).timeout
		
	cards = []
