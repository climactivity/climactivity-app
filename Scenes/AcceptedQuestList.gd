extends SceneBase

var _accepted_quests = []

var bp_quest_card = preload("res://UI/ListEntry.tscn")
onready var quest_list = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/VBoxContainer"
onready var quest_list_empty_message = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/quests_empty_message"
func _ready():
	._ready()
	_accepted_quests = QuestService.get_available_quests()
	QuestService.connect("quest_completed", self, "update")
	update()

#func _enter_tree():
#	update()
func update(): 
	if ready: 
		Util.clear(quest_list)
		var accepted_quests = QuestService.get_available_quests()
		if accepted_quests.empty():
			quest_list_empty_message.visible = true
			quest_list_empty_message.set_text(tr("no_accepted_quests") if QuestService.get_completed_quests().size() == 0 else tr("no_current_accepted_quests"))
			quest_list_empty_message.play_enter()
		for accepted_quest in  accepted_quests:
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
			if aspect.icon != null: 
				quest_card.set_icon(aspect.icon)
			else:
				quest_card.set_icon(sector["sector_logo"])
			quest_card.is_start_hidden(true)
			quest_list.add_child(quest_card)
			$"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/VBoxContainer/Stagger".play_enter()

func receive_navigation(navigation_data): 
	update()

func _restored():
	update()
