extends VBoxContainer

var _accepted_quests = []
var ready = false
var bp_quest_card = preload("res://UI/ListEntry.tscn")

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

			var quest_card = bp_quest_card.instance()
			var quest = QuestService.get_quest_by_id(accepted_quest.quest)
			var aspect = Api.get_aspect_by_name(quest.alert_tracked_aspect)
			var sector = SectorService.get_sector_data(aspect.bigpoint)
			quest_card.set_content_text(quest.title)
			quest_card.set_navigation_target("res://Scenes/QuestScene.tscn",{"quest": quest, "sector": sector, "aspect": aspect})
			quest_card.set_accent_color(sector["sector_color"])
			quest_card.set_reward_display(quest.reward)
			quest_card.set_is_show_progress(true)
			quest_card.set_progress(Util.frac(OS.get_unix_time(), accepted_quest.when, accepted_quest.quest_dead_line))
	#		if quest.has('icon'): 
	#			quest_card_inst.set_icon(factor.icon)
			if aspect.icon != null: 
				quest_card.set_icon(aspect.icon)
			else:
				quest_card.set_icon(sector["sector_logo"])
			add_child(quest_card)
			
func receive_navigation(navigation_data): 
	update()
