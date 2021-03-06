extends PanelContainer

var quest_card = preload("res://UI/ListEntry.tscn")
var _quests = []
var ready = false
var sector
var aspect
export var is_started_icon = preload("res://Assets/Icons/bookmark.png")
export var is_completed_icon = preload("res://Assets/Icons/xp_star.png")
onready var quest_list = $MarginContainer/VBoxContainer/QuestList
func _ready():
	ready = true
	_update()

func load_for_aspect(_aspect):
	aspect = _aspect
	_quests = QuestService.get_quests_for_aspect(aspect._id)
	sector = SectorService.get_sector_data(aspect.bigpoint)
	_update()
	
func _update():

	if _quests == [] or !ready: 
		return
	var reentering = false
	if quest_list.get_child_count() > 1:
		reentering = true
	Util.clear(quest_list)
	for quest in _quests: 
		var quest_card_inst = quest_card.instance()
		#quest_card_inst.set_quest(quest)

		quest_card_inst.set_content_text(quest.title)
		quest_card_inst.set_navigation_target("res://Scenes/QuestScene.tscn",{"quest": quest, "sector": sector, "aspect": aspect})
		quest_card_inst.set_accent_color(sector["sector_color"])
		quest_card_inst.set_reward_display(quest.reward)
		quest_card_inst.is_start_hidden(!reentering)

		if aspect.icon != null: 
			quest_card_inst.set_icon(aspect.icon)
		else:
			quest_card_inst.set_icon(sector["sector_logo"])
		
		var quest_status = QuestService.get_quest_status(quest._id)
		if quest_status != null: 
			if quest_status.has("completed"):
				quest_card_inst.set_icon(is_completed_icon)
			else:
				quest_card_inst.set_is_show_progress(true)
				quest_card_inst.set_progress(Util.frac(OS.get_unix_time(), quest_status.when, quest_status.quest_dead_line))
				quest_card_inst.set_icon(is_started_icon)

		quest_list.add_child(quest_card_inst)
