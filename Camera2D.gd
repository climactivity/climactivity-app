extends Camera2D

var pressed
var cloud_moving 
var zoom_step = 1.1
onready var cursor = $Cursor

func _ready():
	if (is_instance_valid(GameManager.cloud)): 
		GameManager.cloud.connect("cloudMoving", self, "_cloud_moving")

func _cloud_moving(is_moving): 
	cloud_moving = is_moving

func move(offset: Vector2) -> void: 
	print("Move by ", offset)
	self.offset += offset * zoom.x

func zoom_at_point(zoom_change, point):
	var c0 = global_position # camera position
	var v0 = get_viewport().size # vieport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = z0 * zoom_change # next zoom value

	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	zoom = z1
	global_position = c1

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
			cursor.position =  event.global_position
			cursor.monitoring = event.pressed 

		if(event.is_action_pressed("Zoom In")): 
				print("Zoom In")
		if(event.is_action_pressed("Zoom Out")): 
				print("Zoom Out")

	if event is InputEventMouseMotion:
		if pressed && !cloud_moving:
			move(-event.relative)


func _on_Cursor_area_entered(area):
	print(area.name)
