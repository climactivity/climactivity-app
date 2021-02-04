extends Resource

export (int) var updated_at 
export (int) var time_delta
export (String) var bigpoint

#{
#	[aspect_id]: {
#   	reward: RReward
#       apply_to: Board-Entity-ID
#   } 
#}
export (Dictionary) var awarded_tracking_rewards

func compact(date, interval):
	pass

func set_time(new_updated_at, new_time_delta):
	updated_at = new_updated_at
	time_delta = new_time_delta

func add_reward(new_aspect_id, awarded_reward):
	awarded_tracking_rewards[new_aspect_id] = {
		"reward": awarded_reward
	}
