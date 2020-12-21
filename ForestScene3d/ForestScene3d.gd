extends Spatial

func _ready(): 
	$Camera.connect("camera_moved", $Background, "move")
	get_tree().get_root().set_disable_input(true)
	$AnimationPlayer.play("Zoom_To_Clearing")
	GameManager.forest = self

func _input(event):
	if (!OS.is_debug_build()): return
	if (event is InputEventKey and event.scancode == KEY_R and event.is_pressed()):
		GameManager.scene_manager.push_scene("res://UI/Components/QuizList.tscn")
	if (event is InputEventKey and event.scancode == KEY_D and event.is_pressed()):
		pass # todo add debug menu
	if (event is InputEventKey and event.scancode == KEY_S and event.is_pressed()):
		GameManager.save_game()
		#print(save_forest_state())
		
func save_forest_state():
	return $ForestFloor/HexGrid.to_dict()

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Zoom_To_Clearing":
			get_tree().get_root().set_disable_input(false)
		_: 
			return
