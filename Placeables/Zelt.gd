extends Node2D

export var target_sector = "Ernährung"

func _move_to_sector(): 
	var screen_coord = get_viewport_transform() * ( get_global_transform() * position )
	print(screen_coord)
	Transition.transition_to("circle_fade", "res://UI/BigPointScreen.tscn", Vector2(screen_coord.x / get_viewport().size.x, screen_coord.y / get_viewport().size.y))


func _on_PickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		print(event.as_text())
		if event.button_index == BUTTON_LEFT:
			_move_to_sector()
