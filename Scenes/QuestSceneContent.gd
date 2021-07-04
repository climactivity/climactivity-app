tool
extends SceneBase
 

var _quest : RLocalizedQuest
var _active_quest = false
var _quest_status = null 

var not_reentered = false
var just_completed = false
onready var quest_content = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TextContainer/PanelContainer/MarginContainer/Control"
onready var end_date_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/StatusContainer/DatePanel/Label2"
onready var reward_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/StatusContainer/RewardPanel/RewardLabel"
onready var action_button = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/ActionContainer/ActionButton"

func _ready():
	._ready()
	ready = true
	_update()
	
func _update(): 
	if !ready or _quest == null: return
	_quest_status = QuestService.get_quest_status(_quest._id)

	_active_quest = _quest_status != null
	var quest_text = _quest.text["doc"]["content"] if _quest.text.has("doc") else _quest.text["content"]
	quest_content.on_data(quest_text)
	if _active_quest:
		action_button.text = tr("quest_action_in_progress") if not_reentered else tr("quest_action_completable")
		end_date_label.text = Util.date_as_eu_string(QuestService.get_quest_status(_quest._id)["quest_dead_line"])
	else: 
		action_button.text = tr("quest_action_start") if !just_completed else tr("quest_action_just_completed")
		if _quest.deadline != 0: 
			end_date_label.text = Util.date_as_eu_string(_quest.deadline)
		else: 
			end_date_label.text = "%d Tage" % [_quest.max_duration / 24]
	reward_label.set_reward(_quest.reward)
	print(_quest.reward)
	
	var aspect = Api.get_aspect_by_name(_quest.alert_tracked_aspect)
	var sector = SectorService.get_sector_data(aspect.bigpoint)
	
	set_accent_color(sector["sector_color"])
	set_header_icon(aspect.icon if aspect.icon != null else sector["sector_icon"])
func receive_navigation(data):
	not_reentered = false 
	action_button.disabled = false
	if !data.quest: 
		Logger.error("No quest in navigation data!", self)
		return
	_quest = data.quest 
	if _quest.title != "":
		set_screen_title(_quest.title)
	_update()
	

func _on_ActionButton_pressed():
	if _active_quest:
		if !not_reentered:
			QuestService.complete_quest(_quest._id)
			just_completed = true
			action_button.disabled = true
	else:
		QuestService.add_quest(_quest)
		not_reentered = true
		action_button.disabled = true
	_update()
