extends Control



func _on_ActionButton_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/QuestList.tscn")
