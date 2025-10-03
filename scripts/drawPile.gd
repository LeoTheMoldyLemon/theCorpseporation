extends Node3D

class_name DrawPile


static var instance: DrawPile;
func _init():
	DrawPile.instance = self

@export var cardsNode: Node3D
@onready var cardPrefab:PackedScene = preload("res://prefabs/card.tscn")

var cards: Array = []

func draw_card()->Card:
	if(cards.size()==0): 
		await DiscardPile.instance.reshuffle()
	
	return cards.pop_back()

func add_card(card:Card):
	cards.push_back(card)
	card.smooth_move(Transform3D(transform),0.1)
	

func _input(event):
	if(event is InputEventKey && 
	(event as InputEventKey).keycode == Key.KEY_F && 
	(event as InputEventKey).pressed):
		var new_card = cardPrefab.instantiate() as Card
		new_card.transform = Transform3D(transform)
		cardsNode.add_child(new_card)
		add_card(new_card)
