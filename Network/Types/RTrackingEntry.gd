extends Resource

const r_reward = preload("res://Network/Types/RReward.gd")
const reward_base_length: float = float(24*60*60) # day  

export (String) var aspect
export (int) var time_stamp 
export (float) var level 
export (float) var value 
export (Resource) var reward
#"set_at": time_stamp,
#"level?": level, # <- int falls discrete werte, float(0,1) falls contiuum
#"reward": reward,
#"value?": value

func get_reward_for_time_interval(seconds) -> Resource:
	var new_reward = r_reward.new() 
	if seconds <= 0:
		Logger.error("Can only track aspects for positive time intervals!")
		return new_reward
	var factor =  float(seconds) / reward_base_length
	new_reward.xp = reward.xp * factor
	new_reward.coins = reward.coins * factor
	new_reward.water = reward.water * factor
	return new_reward 

func to_dict():
	return {
		"aspect": aspect,
		"time_stamp": time_stamp,
		"level": level,
		"value": value,
		"reward": reward.to_dict()
	}

func _to_string():
	return str(to_dict())
