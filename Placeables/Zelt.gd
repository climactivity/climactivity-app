extends Node2D

export var target_sector = "Ernährung"

var is_loading = false

func _move_to_sector(): 
	#GameManager.scene_manager.push_scene("big_point_scene", {"sector": target_sector})
	GameManager.scene_manager.push_scene("res://UI/Components/QuizList.tscn")
	#is_loading = false
	#var screen_coord = get_viewport_transform() * ( get_global_transform() * position )
	#print(screen_coord)
	#Transition.transition_to("circle_fade", "res://UI/BigPointScreen.tscn", Vector2(screen_coord.x / get_viewport().size.x, screen_coord.y / get_viewport().size.y))


func _on_PickArea_input_event(viewport, event, shape_idx):
	pass
	#if event is InputEventMouseButton:
	#	print(event.as_text())
	#   if event.button_index == BUTTON_LEFT:
	#		_move_to_sector()

func _on_select():
	Logger.print("Moving to %s" % target_sector, self)
	_move_to_sector()

func _on_PickArea_area_entered(area):

	if(area.name == "Cursor"): 
		if (is_instance_valid(GameManager) && is_instance_valid(GameManager.camera)):
			GameManager.camera.call_deferred("clear_events")
		call_deferred("_on_select")

func _on_PickArea_area_exited(area):
	pass

func _unhandled_key_input(event):
	if event is InputEventKey: #You have to make sure, that a key got pressed
		if event.scancode == KEY_R:
			_on_select()
