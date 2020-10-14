extends Camera2D

var pressed

func move(offset: Vector2) -> void: 
	print("Move by ", offset)
	self.offset += offset


func _on_TileMap_move_view(offset):
	move(offset)


func _unhandled_input(event):
	
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position, " Hi from Map")
		pressed = event.pressed

	if event is InputEventMouseMotion:
		if pressed:
			move(-event.relative)
