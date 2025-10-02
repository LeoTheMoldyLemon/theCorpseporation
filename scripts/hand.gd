extends Node3D

class_name Hand

@export var camera: MainCamera;

@onready var max_size: float = camera.get_width_at_z(self.transform.origin.z)*0.7;
@export var max_card_offset: float = 1;
@export var hovered_card_offset: Vector3 = Vector3(0,1,0.5);
@export var hovered_card_towards_camera_offset: float = 0.2;

@export var cards: Array;

@export var discardPile:DiscardPile;
@export var drawPile:DrawPile;


var hovered_card :Card;

func _ready():
	#cards = get_children() as Array
	arrange_cards()

func arrange_cards():
	var offset = max_card_offset;
	if (offset*cards.size() > max_size):
		offset = max_size/cards.size()
	var current_card_x_offset = -offset*(cards.size()-1)/2.0;
	var current_card_z_offset = 0;
	
	for card:Card in cards:
		var card_transform:Transform3D = Transform3D(transform);
		card_transform.origin.x += current_card_x_offset
		card_transform.origin.z += current_card_z_offset
		if(hovered_card==card):
			card_transform.origin += hovered_card_offset
			card_transform.origin += (camera.transform.origin - card_transform.origin)*hovered_card_towards_camera_offset
		card.smooth_move(card_transform, 0.05)
		current_card_x_offset+=offset;
		current_card_z_offset+=0.05
		
func add_card(card:Card):
	cards.push_back(card)
	arrange_cards()

func play_card(slot:CreatureSlot):
	if(!hovered_card): pass;
	cards.erase(hovered_card)
	arrange_cards()
	slot.add_card(hovered_card)

func discard_card(card:Card):
	if(cards.find(card)==-1): pass;
	cards.erase(hovered_card)
	arrange_cards()
	discardPile.add(card)
	

func _input(event):
		
	if(event is InputEventMouseMotion && !Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT)):
		var raycast_result = camera.get_mouse_raycast(1)
		var new_hovered_card = null
		if(raycast_result):
			new_hovered_card = (raycast_result["collider"] as Area3D).get_parent()
			if(cards.find(new_hovered_card)==-1):
				new_hovered_card=null;
		
		if(hovered_card!=new_hovered_card):
			hovered_card = new_hovered_card
			arrange_cards()
	
	if(event is InputEventMouseButton && 
	(event as InputEventMouseButton).button_index==1 &&
	(event as InputEventMouseButton).is_released()):
		var raycast_result = camera.get_mouse_raycast(1)
		if(raycast_result):
			var hovered_slot = (raycast_result["collider"] as Area3D).get_parent()
			if(hovered_slot is CreatureSlot):
				play_card(hovered_slot)
		
