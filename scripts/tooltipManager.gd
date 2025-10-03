extends Node


var current_tooltip: Tooltip;

func _input(event):
	if(event is InputEventMouseMotion):
		var raycast_result =  MainCamera.instance.get_mouse_raycast(3)
		if(raycast_result):
			var tooltip = (raycast_result["collider"] as Area3D).get_parent() as Tooltip
			if(tooltip!=current_tooltip):
				if(current_tooltip): current_tooltip.visible=false
				current_tooltip=tooltip
				if(current_tooltip): current_tooltip.visible=true
		else:
			if(current_tooltip): current_tooltip.visible=false
			current_tooltip=null
			

	
