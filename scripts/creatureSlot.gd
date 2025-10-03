extends Node3D

class_name CreatureSlot


@export var current_card:Card;

func _ready():
	if(current_card):
		current_card.smooth_move(Transform3D(transform), 0)


func add_card(card:Card):
	assert(current_card == null)
	current_card = card
	card.smooth_move(Transform3D(transform), 0.2)
	
	
func discard_card():
	if(!current_card): return;
	DiscardPile.instance.add_card(current_card)
	remove_card()
	
func remove_card():
	current_card=null
