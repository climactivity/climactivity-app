extends VBoxContainer

var _accepted_quests = []
var ready = false
var bp_quest_card = QuestCard

func _ready():
	_accepted_quests = QuestService.get_available_quests()
	ready = true
	update()
	
func update(): 
	if ready: 
		for accepted_quest in _accepted_quests:
			var quest_card = QuestCard.instance()
			quest_card.set_quest(accepted_quest.quest)
			
