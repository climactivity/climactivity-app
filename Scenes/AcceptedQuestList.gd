extends VBoxContainer

var _accepted_quests = []
var ready = false
var bp_quest_card = preload("res://UI/Components/QuestCard.tscn")

func _ready():
	_accepted_quests = QuestService.get_available_quests()
	QuestService.connect("quest_completed", self, "update")
	ready = true
	update()

func _enter_tree():
	update()
func update(): 
	if ready: 
		Util.clear(self)
		for accepted_quest in  QuestService.get_available_quests():
			print(accepted_quest)
			var quest_card = bp_quest_card.instance()
			quest_card.set_quest_id(accepted_quest.quest)
			add_child(quest_card)
			
func receive_navigation(navigation_data): 
	update()
