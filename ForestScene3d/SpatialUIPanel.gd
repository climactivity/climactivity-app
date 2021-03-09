extends Spatial

signal clicked

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton: 
		if event.pressed:
			emit_signal("clicked")
