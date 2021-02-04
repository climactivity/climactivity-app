extends Resource

export (String) var bigpoint
export (String) var aspect
export (Resource) var current
export (Array) var history
export (Resource) var water_tank
export (int) var run_time # in days

##example value 
#{
#	"bigpoint": bigpoint,
#	"current": history[0],
#	"history": [{
#		"set_at": time_stamp,
#		"level?": level, # <- int falls discrete werte, float(0,1) falls contiuum
#		"reward": reward,
#		"value?": value
#	}]
#}

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
func make_tracking_state(new_entry, new_run_time): 
	history = []
	history.push_front(new_entry)
	current = new_entry
	run_time = new_run_time
	# TODO make water tank
