extends Node3D

class_name CreatureSlot


@export var current_card:Card;
@export var discardPile:DiscardPile;

func _ready():
	if(current_card):current_card.smooth_move(Transform3D(transform), 0)


func add_card(card:Card):
	assert(current_card == null)
	card.smooth_move(Transform3D(transform), 0.2)
	
	
func discard_card():
	if(!current_card): pass;
	discardPile.add(current_card)
	current_card=null
	
func remove_card():
	current_card=null
	
