extends Node3D

class_name DrawPile

@export var cards: Node3D
@onready var cardPrefab:PackedScene = preload("res://prefabs/card.tscn")


func _input(event):
	if(event is InputEventKey && 
	(event as InputEventKey).keycode == Key.KEY_F && 
	(event as InputEventKey).pressed):
		cards.add_child(cardPrefab.instantiate())
