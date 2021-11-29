extends Control



func _on_ActionButton_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/QuestList.tscn")


func _on_BilanzierungButton_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/BigPointScene.tscn", {
		"sector": "energy",
		"sector_title": "Zelt der Beep",
		"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Energie.png")
	})
