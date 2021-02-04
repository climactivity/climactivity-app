extends Resource

export (String) var _id
export (float)  var water
export (float)  var coins
export (float)  var xp 
export (Array)  var trigger = null

#might kill trigg
func merge(other_reward):
	water = water + other_reward.water
	coins = coins + other_reward.coins
	xp = xp + other_reward.xp
	if trigger == null: 
		trigger = other_reward.trigger 
	elif other_reward.trigger == null: 
		return
	else: 
		trigger = other_reward.trigger

func to_dict():
	return {
		"_id": _id,
		"water": water,
		"coins": coins,
		"xp": xp,
		"trigger": trigger
	}

func _to_string():
	return str(to_dict())
