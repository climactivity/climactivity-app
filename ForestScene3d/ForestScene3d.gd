extends Spatial
signal update_hud
func _ready(): 
	$Camera.connect("camera_moved", $Background, "move")
	Api.connect("cache_ready", self, "enter_game")
	get_tree().get_root().set_disable_input(true)
	$AnimationPlayer.play("Zoom_To_Clearing")
	GameManager.forest = self
	$Camera/HUD/DebugMenu.connect("free_place", $ForestFloor/HexGrid, "set_free_place")
	connect("update_hud", $Camera/HUD, "update_hud")
	connect("update_hud", $Camera/HUD/Cloud, "update_water_available")
	if is_instance_valid(AspectTrackingService): connect("update_hud", AspectTrackingService, "notify_watered_aspects")
	$ForestFloor/HexGrid.connect("placed_entity", $Camera/HUD, "update_hud")
func _input(event):
	if (!OS.is_debug_build()): return
	if (event is InputEventKey and event.scancode == KEY_R and event.is_pressed()):
		GameManager.scene_manager.push_scene("res://UI/Components/QuizList.tscn")
	if (event is InputEventKey and event.scancode == KEY_D and event.is_pressed()):
		$ForestFloor/HexGrid.show_grid(!$ForestFloor/HexGrid.is_showing_grid())
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

func _restored():
	Logger.print("_restored", self)
	emit_signal("update_hud")
	if GameManager != null: 
		GameManager.menu.show_menu()
		GameManager.menu.set_navigation_state( MainMenu.Navigation_states.HOME ,true)

