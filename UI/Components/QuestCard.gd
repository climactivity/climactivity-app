tool 
extends PanelContainer
class_name QuestCard

export (Resource) var _quest setget set_quest 
var _is_accepted = false setget set_is_accepted
onready var title_label = $MarginContainer/HBoxContainer/VBoxContainer/Label
onready var reward_label = $MarginContainer/HBoxContainer/VBoxContainer/RewardLabel
onready var icon = $MarginContainer/HBoxContainer/Capsule

var ready = false

func _ready(): 
	ready = true
	_update()

func set_quest(quest):
	_quest = quest 
	_update()

func set_is_accepted(is_accepted): 
	_is_accepted = is_accepted
	

func _update(): 
	if !ready or _quest == null: return
	title_label.text = _quest.title 
	reward_label.set_reward(_quest.reward)
#	icon.set_icon(_quest.icon)

func _on_QuestCard_gui_input(event):
	if event is InputEventScreenTouch and event.pressed: 
		GameManager.scene_manager.push_scene("res://Scenes/QuestScene.tscn",{"quest": _quest})


func _on_Panel_gui_input(event):
	_on_QuestCard_gui_input(event)



func _on_gui_input(event):
	_on_QuestCard_gui_input(event)
