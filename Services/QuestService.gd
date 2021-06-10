extends Node

var _accepted_quests : Array

func _ready():
	var _player_state = PSS.get_player_state_ref()
	_accepted_quests = _player_state.current_quests

func get_available_quests() -> Array: 
	return _accepted_quests

func get_quests_for_aspect(aspect):
	return Api.cache.get_quests_for_aspect(aspect)

func complete_quest(quest_id): 
	pass

func _flush(): 
	PSS.flush()

func add_quest(quest): 
	_accepted_quests.push_back({"quest": quest, "when": OS.get_unix_time()})
	_flush()
