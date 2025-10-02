extends Node3D

class_name DiscardPile

var cards: Array = []

func empty():
	cards = []
	
func add(card:Card):
	cards.push_back(card)
	card.smooth_move(Transform3D(transform), 0.2)
