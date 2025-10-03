extends Node3D

class_name Card


@onready var target:Transform3D = Transform3D(transform);
var smooth_move_time :float=0;
var following_mouse:bool = false;

func smooth_move(xtrans:Transform3D, time:float = 0.5):
	target=xtrans
	smooth_move_time=time
	

func _process(delta:float):
	if(following_mouse):
		transform.origin.x+=(MainCamera.instance.get_mouse_pos_at_z(transform.origin.z).x-transform.origin.x)*delta/0.1
		transform.origin.y+=(MainCamera.instance.get_mouse_pos_at_z(transform.origin.z).y-transform.origin.y)*delta/0.1
	else:
		if(smooth_move_time!=0):
			transform = transform.interpolate_with(target, delta/smooth_move_time)
			smooth_move_time-=delta
		if(smooth_move_time<0.0):
			smooth_move_time = 0;
			transform = target
		



func start_follow_mouse():
	following_mouse = true

func stop_follow_mouse():
	following_mouse = false
	
	
