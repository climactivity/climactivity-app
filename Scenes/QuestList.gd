extends PanelContainer

var quest_card = preload("res://UI/ListEntry.tscn")
var _quests = []
var ready = false
var sector
var aspect
export var is_started_icon = preload("res://Assets/Icons/bookmark.png")
export var is_completed_icon = preload("res://Assets/Theme/Checkmark.png")
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
	_quests.sort_custom(self, "custom_sort_quests")
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
				quest_card_inst.set_accent_color(sector["sector_color"].lightened(0.3))
			else:
				quest_card_inst.set_is_show_progress(true)
				quest_card_inst.set_progress(Util.frac(OS.get_unix_time(), quest_status.when, quest_status.quest_dead_line))
				quest_card_inst.set_icon(is_started_icon)

		quest_list.add_child(quest_card_inst)

func custom_sort_quests(q1, q2):
	var q2_status = QuestService.get_quest_status(q2._id)
	var q1_status = QuestService.get_quest_status(q1._id)
	if q1_status != null and q2_status != null: 
		if q1_status.has("completed") and q2_status.has("completed"):
			return q1_status.completed < q2_status.completed
		elif q1_status.has("completed") and !q2_status.has("completed"):
			return false
		elif !q1_status.has("completed") and q2_status.has("completed"):
			return true
		else:
			return q1_status.when < q2_status.when
	elif q1_status != null and q2_status == null: 
		return false
	elif q1_status == null and q2_status != null: 
		return true
	else:
		return q1.start_date < q2.start_date
