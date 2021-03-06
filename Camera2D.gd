extends Camera2D

var pressed
var cloud_moving 
var zoom_step = 1.1
var initial_offset = Vector2.ZERO
export(NodePath) var cursor_path
var cursor

func _ready():
	initial_offset = offset
	cursor = get_parent().get_child(0)
	GameManager.camera = self
	if (is_instance_valid(GameManager.cloud)): 
		GameManager.cloud.connect("cloudMoving", self, "_cloud_moving")

func _cloud_moving(is_moving): 
	cloud_moving = is_moving

func move(offset: Vector2) -> void: 
	self.offset += offset * zoom.x

func zoom_at_point(zoom_change, point):
	var c0 = global_position # camera position
	var v0 = get_viewport().size # vieport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = z0 * zoom_change # next zoom value

	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	zoom = z1
	offset += c1

func _on_TileMap_move_view(offset):
	move(offset)

func _unhandled_input(event):
	if event is InputEventMouse:
		if event.is_pressed():
			var mouse_position = event.position
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_at_point(1/zoom_step,mouse_position)
			else : if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_at_point(zoom_step,mouse_position)
					
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			pressed = event.pressed
			var viewport_size = get_viewport_rect().size
			var cursor_pos =  event.position 
			cursor_pos = cursor_pos * zoom + (viewport_size / 2.0) * (1.0 - zoom.x) # apply zoom  
			cursor_pos = cursor_pos + offset - initial_offset # reset from initial offset
			cursor.position =  cursor_pos
			cursor.monitoring = event.pressed 
			cursor.monitorable = event.pressed 
	if event is InputEventMouseMotion:
		if pressed && !cloud_moving:
			move(-event.relative)

func _on_Cursor_area_entered(area):
	pass
	#print( area.get_parent().name if is_instance_valid(area.get_parent()) else area.name)

func clear_events():
	cursor.monitoring = false 
	cursor.monitorable = false
	pressed = false 
