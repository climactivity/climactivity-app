extends Control

export (Resource) var quiz

var factors setget set_factors
onready var 
func _on_Capsule_clicked():
	if GameManager != null and quiz != null:
		Logger.print( "Loading quiz: %s" % quiz.name , self)
		GameManager.scene_manager.push_scene("res://Scenes/QuizScene.tscn", {"quiz": quiz})

func set_factors(new_factors = []): 
	factors = new_factors
	for factor in factors: 
		
