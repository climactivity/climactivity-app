tool
extends Camera

signal camera_moved(position)
signal camera_rotated(rotation)
signal consuming_gesture()
signal release_gesture()
# """ exports zoom level
# """ used to determine distance above origin and tilt
export var zoom_level = 1.0
export var zoom_factor = 1.0
export (float) var pan_factor = 4.0

export var min_elevation = 5.00 
export var max_elevation = 30

export var min_rotation_deg = -27.5
export var max_rotation_deg = -45.0

export var nw_bound = Vector2(-15.0,-5.0)
export var se_bound = Vector2(15.0,5.0)

var saved_position 
var current_position
var target_position
var focused_entity
var t = 0.0
var focused = false
func focus_entity(entity):
	if (entity.has_method("focus_entity")): 
		focused_entity = entity
		saved_position = Transform(global_transform) 
		current_position = Transform(global_transform) 
		target_position = Transform( entity.focus_entity().global_transform )
		set_process_input(false)
		if entity.has_method("get_details_widget"):
			$"HUD/EntityDetails/MarginContainer/PanelContainer/MountPoint".add_child(entity.get_details_widget())
		$"../AnimationPlayer".play("ShowEntityDetails")

func _entity_focused(): 
	focused = true
	
func unfocus_entity():
	if focused_entity == null:
		set_process_input(true) 
	focused_entity = null 
	focused = false
	current_position = Transform(global_transform) 
	$"../AnimationPlayer".play("HideEntityDetails")

func _entity_unfocused():
	set_process_input(true) 
	target_position = null
	Util.clear($"HUD/EntityDetails/MarginContainer/PanelContainer/MountPoint")

func _physics_process(delta):
	if focused_entity != null and not focused:
		t += delta
		if t > 1.0: 
			t = 0.0
			_entity_focused()
		else:
			global_transform = current_position.interpolate_with(target_position, t)
	elif focused_entity == null and not focused and target_position != null:
		t += delta
		if t > 1.0: 
			t = 0.0
			_entity_unfocused()
		else:
			global_transform = current_position.interpolate_with(saved_position, t)

func _ready():
	if is_instance_valid(GameManager):
		GameManager.camera = self
	_zoom(0.0)

func _zoom(delta: float): 
	var old_translation = global_transform.origin; 
	var new_elevation = clamp(old_translation.y + delta * zoom_factor, min_elevation, max_elevation)
	#print(new_elevation)
	global_transform.origin = Vector3(old_translation.x, new_elevation, old_translation.z)
	rotation.x = deg2rad(_get_rotation_for_y(global_transform.origin.y))
	emit_signal("camera_rotated", rotation.x)

func _get_rotation_for_y(y: float): 
	var deg = Util.map_to_range(get_elevation_percent(),0.0,1.0,min_rotation_deg, max_rotation_deg)
	#print(deg)
	return deg
	
func _pan(delta: Vector2): 
	var current_pan_factor = (pan_factor/100.0) * max(get_elevation_percent(),0.05)
	var pan_by = Vector3(delta.x, 0.0, delta.y) * current_pan_factor

	var old_origin = global_transform.origin
	var new_origin = old_origin + pan_by
	new_origin = Vector3(
		clamp(new_origin.x, nw_bound.x, se_bound.x),
		new_origin.y,
		clamp(new_origin.z, nw_bound.y, se_bound.y)
	)
	#print(new_origin)
	global_transform.origin = new_origin
	emit_signal("camera_moved", new_origin - old_origin)

func _unhandled_input(event):
	if event is InputEventMouse:
		if event.is_pressed():
			var mouse_position = event.position
			if event.button_index == BUTTON_WHEEL_UP:
				_zoom(-1.0)
			else : if event.button_index == BUTTON_WHEEL_DOWN:
				_zoom(1.0)

	if event is InputEventScreenDrag:
		emit_signal("consuming_gesture")
		_pan(-event.relative)
	else: 
		emit_signal("release_gesture")

				
func get_elevation_percent():
	return Util.map_to_range(global_transform.origin.y,min_elevation, max_elevation, 0.0, 1.0)

func ray_cast(screen_pos):
	var from = project_ray_origin(screen_pos)
	var to = from + project_ray_normal(screen_pos) * 10000
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to)
	return result


func _on_DetailsBG_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		unfocus_entity()
