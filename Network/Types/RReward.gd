extends Resource
class_name RReward

export (String) var _id
export (float)  var water
export (float)  var coins
export (float)  var xp 
export (Array)  var trigger = null

static func from_dict(dict): 
	var _reward = load("res://Network/Types/RReward.gd").new()
	_reward._id =  dict["_id"] if dict.has("_id") else "-1"
	_reward.water =  dict["water"]  if dict.has("_id") else 0
	_reward.coins =  dict["coins"] if dict.has("_id") else 0
	_reward.xp =  dict["xp"] if dict.has("_id") else 0
	_reward.trigger =  dict["trigger"] if dict.has("_id") else []

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
