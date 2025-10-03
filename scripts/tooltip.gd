extends PanelContainer

class_name Tooltip

@export var offset:Vector2 = Vector2(10,10)

func _input(event):
	if(!visible): return;
	if(event is InputEventMouseMotion):
		global_position=get_global_mouse_position()+offset
