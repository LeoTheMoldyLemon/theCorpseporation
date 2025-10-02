extends Node3D

class_name Card


@onready var target:Transform3D = Transform3D(transform);
var smooth_move_time :float=0;

func smooth_move(xtrans:Transform3D, time:float = 0.5):
	target=xtrans
	smooth_move_time=time
	

func _process(delta:float):
	if(smooth_move_time!=0):
		transform = transform.interpolate_with(target, delta/smooth_move_time)
		smooth_move_time-=delta
	if(smooth_move_time<0.0):
		smooth_move_time = 0;
		transform = target
		
	
