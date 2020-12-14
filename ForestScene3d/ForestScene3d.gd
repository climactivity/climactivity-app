extends Spatial

func _ready(): 
	$Camera.connect("camera_moved", $Background, "move")

func _input(event):
	if (!OS.is_debug_build()): return
	if (event is InputEventKey and event.scancode == KEY_R and not event.echo):
		GameManager.scene_manager.push_scene("res://UI/Components/QuizList.tscn")
	if (event is InputEventKey and event.scancode == KEY_D and not event.echo):
		pass # todo add debug menu
	if (event is InputEventKey and event.scancode == KEY_S and not event.echo):
		_save_game()
		


func _save_game():
	print($ForestFloor/HexGrid.to_json())
