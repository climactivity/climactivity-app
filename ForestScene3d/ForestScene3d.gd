extends Spatial

func _ready(): 
	$Camera.connect("camera_moved", $Background, "move")

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_R and not event.echo):
		GameManager.scene_manager.push_scene("res://UI/Components/QuizList.tscn")
