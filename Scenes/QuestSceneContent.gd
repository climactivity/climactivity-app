tool
extends Control
 

var _quest
var _active_quest = false 
var ready = false

onready var quest_content = $"Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TextContainer/PanelContainer/MarginContainer/Control"
onready var end_date_label = $"Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/StatusContainer/DatePanel/Label2"
onready var reward_label = $"Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/StatusContainer/RewardPanel/Label"
onready var action_button = $"Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/ActionContainer/ActionButton"

func _ready():
	ready = true
	_update()
	
func _update(): 
	if !ready or _quest == null: return
	quest_content.on_data(_quest.text["content"])

func receive_navigation(data): 
	_quest = data.quest if data.quest else {}
	_active_quest = data.quest_active if data.quest_active else false
	if _quest == {}: 
		Logger.error("No quest in navigation data!", self)
	_update()
	

func _on_ActionButton_pressed():
	QuestService.add_quest(_quest)
