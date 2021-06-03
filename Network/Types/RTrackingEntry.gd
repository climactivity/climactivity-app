extends Resource

const r_reward = preload("res://Network/Types/RReward.gd")
const reward_base_length: float = float(24*60*60) # day  

export (String) var aspect
export (int) var time_stamp 
export (float) var level 
export (float) var value 
export (Resource) var reward
export (float) var water_factor
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
	new_reward.xp = float(reward.xp) * factor
	new_reward.coins = float(reward.coins) * factor
	new_reward.water = float(reward.water) * factor
	return new_reward 

func get_water_from_factor(seconds) -> float: 
	if seconds <= 0:
		Logger.error("Can only track aspects for positive time intervals!")
		return 0.0
	var factor =  float(seconds) / reward_base_length
	return water_factor * factor

func to_dict():
	return {
		"aspect": aspect,
		"time_stamp": time_stamp,
		"level": level,
		"value": value,
		"reward": reward.to_dict(),
		"water_factor": water_factor
	}

func _to_string():
	return str(to_dict())
