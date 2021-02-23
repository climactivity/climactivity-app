extends Resource

export (String) var bigpoint
export (String) var aspect
export (Resource) var current
export (Array) var history
export (Resource) var water_tank
export (int) var run_time # in days
export (Resource) var current_entity
export (Array) var entity_list
export (bool) var new_seedling_available = false

func get_reward_for_time_interval_from_now(seconds) -> Resource:
	var current_state_since = OS.get_unix_time() - current.time_stamp
	if seconds <= current_state_since:	
		return current.get_reward_for_time_interval(seconds)
	else: 
		var reward = null
		var remaining = seconds
		var last_time_stamp = OS.get_unix_time()
		for entry in history: 
			var applied_time =  last_time_stamp - entry.time_stamp
			var current_reward =  entry.get_reward_for_time_interval(min(applied_time, remaining))
			remaining -= applied_time
			if reward == null:
				reward = current_reward
			else:
				reward.merge(current_reward)
			if remaining <= 0: 
				break
		return reward
		

# cannot go into _init() because resources need to have a no args constructor to deserialize properly
func make_tracking_state(new_bigpoint, new_aspect, new_entry, new_run_time): 
	bigpoint = new_bigpoint
	aspect = new_aspect
	history = []
	history.push_front(new_entry)
	current = new_entry
	run_time = new_run_time
	# TODO make water tank
	if current_entity == null: 
		new_seedling_available = true


func _to_string():
	return str(to_dict())

func to_dict(): 
	var out = {

	  "bigpoint" : bigpoint,
	  "aspect" : aspect,
	  "current" : current.to_dict(),
	  "history" : Util.flatten_array(history),
	  "water_tank" : water_tank,
	  "run_time" : run_time, # in days
	}
	#Logger.print(out)
	return out

func get_water_available():
	if water_tank == null: return 0.0
	return water_tank.get_water_amount()

func get_water_percent_available(): 
	return water_tank.get_water_amount() / water_tank.max_value

func get_water_tank_size(): 
	return water_tank.max_value

func get_aspect_data():
	return Api.get_aspect_by_name(aspect)
	
