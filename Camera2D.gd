extends Camera2D

var pressed
var cloud_moving 

func _ready():
	if (is_instance_valid(GameManager.cloud)): 
		GameManager.cloud.connect("cloudMoving", self, "_cloud_moving")

func _cloud_moving(is_moving): 
	cloud_moving = is_moving

func move(offset: Vector2) -> void: 
	print("Move by ", offset)
	self.offset += offset


func _on_TileMap_move_view(offset):
	move(offset)


func _unhandled_input(event):
	
	if event is InputEventMouseButton:

		pressed = event.pressed
		if(event.is_action_pressed("Zoom In")): 
				print("Zoom In")
		if(event.is_action_pressed("Zoom Out")): 
				print("Zoom Out")

	if event is InputEventMouseMotion:
		if pressed && !cloud_moving:
			move(-event.relative)
