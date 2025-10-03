extends Node3D

class_name Hand


static var instance: Hand;
func _init():
	Hand.instance = self

@onready var max_size: float =  MainCamera.instance.get_width_at_z(self.transform.origin.z)*0.7;
@export var max_card_offset: float = 1;
@export var hovered_card_offset: Vector3 = Vector3(0,1,0.5);
@export var hovered_card_towards_camera_offset: float = 0.2;

@export var cards: Array;

var hovered_card :Card;
var is_dragging: bool = false;

func _ready():
	#cards = get_children() as Array
	arrange_cards()

func arrange_cards():
	var offset = max_card_offset;
	if (offset*cards.size() > max_size):
		offset = max_size/cards.size()
	var current_card_x_offset = -offset*(cards.size() - (2 if is_dragging else 1) )/2.0;
	var current_card_z_offset = 0;
	
	for card:Card in cards:
		var card_transform:Transform3D = Transform3D(transform);
		card_transform.origin.x += current_card_x_offset
		card_transform.origin.z += current_card_z_offset
		if(hovered_card==card):
			if(is_dragging): continue;
			card_transform.origin += hovered_card_offset
			card_transform.origin += (MainCamera.instance.transform.origin - card_transform.origin)*hovered_card_towards_camera_offset
		card.smooth_move(card_transform, 0.05)
		current_card_x_offset+=offset;
		current_card_z_offset+=0.05
		
func add_card(card:Card):
	cards.push_back(card)
	arrange_cards()

func play_card(slot:CreatureSlot):
	if(!hovered_card || slot.current_card != null): return;
	cards.erase(hovered_card)
	slot.add_card(hovered_card)
	hovered_card = null
	arrange_cards()

func discard_card(card:Card):
	if(cards.find(card)==-1): return;
	cards.erase(hovered_card)
	arrange_cards()
	DiscardPile.instance.add_card(card)
	
func draw_cards(num:int):
	for i in range(num):
		var card = await DrawPile.instance.draw_card()
		if card:
			add_card(card)
		else:
			break;
		await get_tree().create_timer(0.1).timeout
	


func _input(event):
	
	if(event is InputEventKey && 
	(event as InputEventKey).keycode == Key.KEY_G && 
	(event as InputEventKey).pressed):
		draw_cards(5)
		
		
	if(event is InputEventMouseMotion):
		if(!is_dragging):
			var raycast_result =  MainCamera.instance.get_mouse_raycast(1)
			var new_hovered_card = null
			if(raycast_result):
				new_hovered_card = (raycast_result["collider"] as Area3D).get_parent()
				if(cards.find(new_hovered_card)==-1):
					new_hovered_card=null;
			
			if(hovered_card!=new_hovered_card):
				hovered_card = new_hovered_card
				arrange_cards()
	
	
	if(event is InputEventMouseButton):
		if((event as InputEventMouseButton).button_index==1):
			if((event as InputEventMouseButton).is_pressed()):
				if(hovered_card):
					is_dragging=true
					hovered_card.start_follow_mouse()
					arrange_cards()
			else:
				is_dragging=false
				
				if(hovered_card):
					hovered_card.stop_follow_mouse()
					arrange_cards()
					var raycast_result =  MainCamera.instance.get_mouse_raycast(2)
					if(raycast_result):
						var hovered_slot = (raycast_result["collider"] as Area3D).get_parent()
						if(hovered_slot is CreatureSlot):
							play_card(hovered_slot)
		elif((event as InputEventMouseButton).button_index==2):
			if((event as InputEventMouseButton).is_pressed()):
				var raycast_result =  MainCamera.instance.get_mouse_raycast(2)
				if(raycast_result):
					var hovered_slot = (raycast_result["collider"] as Area3D).get_parent()
					if(hovered_slot is CreatureSlot):
						hovered_slot.discard_card()
		
		
