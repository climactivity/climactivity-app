extends PanelContainer

var quest_card = preload("res://UI/Components/QuestCard.tscn")
var _quests = []
var ready = false
onready var quest_list = $MarginContainer/VBoxContainer/QuestList
func _ready():
	ready = true
	_update()

func load_for_aspect(aspect):
	_quests = QuestService.get_quests_for_aspect(aspect)
	_update()
	
func _update():
	if _quests == [] or !ready: 
		return
	Util.clear(quest_list)
	for quest in _quests: 
		var quest_card_inst = quest_card.instance()
		quest_card_inst.set_quest(quest)
		quest_list.add_child(quest_card_inst)
