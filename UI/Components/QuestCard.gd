tool 
extends PanelContainer
class_name QuestCard

export (Resource) var _quest setget set_quest 

onready var title_label = $MarginContainer/HBoxContainer/VBoxContainer/Label
onready var reward_label = $MarginContainer/HBoxContainer/VBoxContainer/RewardLabel
onready var icon = $MarginContainer/HBoxContainer/Capsule

func set_quest(quest):
	_quest = quest 
	_update()
	
func _update(): 
	title_label.text = _quest.title 
	reward_label.set_reward(_quest.reward)
	icon.set_icon(_quest.icon)

func _on_QuestCard_gui_input(event):
	if event is InputEventScreenTouch and event.pressed: 
		GameManager.scene_manager.push_scene("res://Scenes/QuestScene.tscn",{"quest": _quest})


func _on_Panel_gui_input(event):
	_on_QuestCard_gui_input(event)



func _on_gui_input(event):
	_on_QuestCard_gui_input(event)
