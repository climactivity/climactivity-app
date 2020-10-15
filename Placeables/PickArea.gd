extends Area2D


# Declare member variables here. Example				print("Zoom In")s:
# var a = 2
# var b = "text"


func _on_PickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			print("Hello from ", name )

