extends Node

signal complete
signal quest_completed(quest_id)
var _accepted_quests : Array
var _completed_quests : Array

func _ready():
	var _player_state = PSS.get_player_state_ref()
	_accepted_quests = _player_state.current_quests
	_completed_quests = _player_state.completed_quests
	
func get_available_quests() -> Array: 
	return _accepted_quests

func get_completed_quests() -> Array:
	return _completed_quests

func get_quest_by_id(quest_id):
	return Api.cache.get_quest_by_id(quest_id)

func get_quests_for_aspect(aspect):
	return Api.cache.get_quests_for_aspect(aspect)

func complete_quest(quest_id): 
	for accepted_quest in _accepted_quests:
		if accepted_quest.quest == quest_id:
			_accepted_quests.erase(accepted_quest)
			_reward_quest(accepted_quest)
			accepted_quest["completed"] = OS.get_unix_time()
			_completed_quests.append(accepted_quest)
			emit_signal("quest_completed", quest_id)
			_flush()
			return

func _reward_quest(acceped_quest):
	var quest = get_quest_by_id(acceped_quest.quest)
	if quest == null:
		Logger.error("Quest % not found" % acceped_quest.quest, self)
		return 
	var reward = quest.reward
	RewardService.add_reward(reward)

func _flush(): 
	PSS.flush()

func add_quest(quest: RLocalizedQuest): 
	var quest_dead_line = quest.deadline if quest.deadline != 0 else (quest.max_duration * Util.HOUR) + OS.get_unix_time()
	_accepted_quests.push_back({"quest": quest._id, "when": OS.get_unix_time(), "quest_dead_line": quest_dead_line})
	_flush()
	emit_signal("complete")
	return self

func get_quest_status(quest_id): 
	for accepted_quest in _accepted_quests:
		if accepted_quest.quest == quest_id:
			return accepted_quest
	for completed_quest in _completed_quests: 
		if completed_quest.quest == quest_id:
			if !completed_quest.has("completed"):
				completed_quest["completed"] = OS.get_unix_time()
			return completed_quest
	return null
