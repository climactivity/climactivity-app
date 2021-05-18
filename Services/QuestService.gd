extends Node

func get_available_quests(): 
	pass

func get_quests_for_aspect(aspect):
	return Api.cache.get_quests_for_aspect(aspect)

func complete_quest(quest_id): 
	pass

func _flush(): 
	pass

func add_quest(quest): 
	pass
