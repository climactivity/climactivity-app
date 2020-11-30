extends Node2D

export var target_sector = "Ernährung"

var is_loading = false

func _move_to_sector(): 
	if is_loading: return
	is_loading = true
	#GameManager.scene_manager.push_scene("big_point_scene", {"sector": target_sector})
	GameManager.scene_manager.push_scene("res://UI/QuizList.tscn")
	is_loading = false
	#var screen_coord = get_viewport_transform() * ( get_global_transform() * position )
	#print(screen_coord)
	#Transition.transition_to("circle_fade", "res://UI/BigPointScreen.tscn", Vector2(screen_coord.x / get_viewport().size.x, screen_coord.y / get_viewport().size.y))


func _on_PickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		print(event.as_text())
		if event.button_index == BUTTON_LEFT:
			_move_to_sector()

func _on_select():
	print("entering... ")
	_move_to_sector()

func _on_PickArea_area_entered(area):
	if(area.name == "Cursor"): 
		print("_on_select ",get_parent().name) 
		call_deferred("_on_select")
