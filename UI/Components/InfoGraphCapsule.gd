extends MarginContainer

export (Resource) var quiz

func _on_Capsule_clicked():
	if GameManager != null and quiz != null:
		Logger.print( "Loading quiz: %s" % quiz.name , self)
		GameManager.scene_manager.push_scene("res://UI/QuizScene.tscn", {"quiz": quiz})
