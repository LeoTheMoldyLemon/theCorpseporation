extends Camera3D

class_name MainCamera

static var instance: MainCamera;
func _init():
	MainCamera.instance = self

func get_width_at_z(z:float):
	return self.get_height_at_z(z)* get_viewport().size.aspect();
	
func get_height_at_z(z:float):
	return 2.0 * (10-z) * tan(deg_to_rad(self.fov) / 2.0);


var mouse_position: Vector2 = Vector2(0,0);
func _input(event:InputEvent): 
	if(event is InputEventMouseMotion):
		mouse_position=(event as InputEventMouseMotion).position

func get_mouse_pos_at_z(z:float) -> Vector3:
	return self.project_position(mouse_position, 10-z)

func get_mouse_raycast(mask:int)-> Dictionary:
	var start = self.project_ray_origin(mouse_position)
	var end = get_mouse_pos_at_z(-100)
	var raycastParameters = PhysicsRayQueryParameters3D.create(start, end, mask);
	raycastParameters.collide_with_areas = true;
	return get_world_3d().direct_space_state.intersect_ray(raycastParameters)
	
	
	
