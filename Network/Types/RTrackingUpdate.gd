extends Resource
class_name RTrackingUpdate

export (int) var updated_at 
export (int) var time_delta

#{
#	[aspect_id]: {
#   	reward: RReward
#       apply_to: Board-Entity-ID
#   } 
#}
export (Dictionary) var awarded_tracking_rewards

func set_time(new_updated_at, new_time_delta):
	updated_at = new_updated_at
	time_delta = new_time_delta

func add_reward(new_aspect_id, awarded_reward):
	awarded_tracking_rewards[new_aspect_id] = {
		"reward": awarded_reward
	}

func merge(tracking_update):
	updated_at = max(self.updated_at, tracking_update.updated_at)
	time_delta = time_delta + tracking_update.time_delta
	for aspect_id in tracking_update.awarded_tracking_rewards.keys(): 
		if awarded_tracking_rewards.has(aspect_id): 
			awarded_tracking_rewards[aspect_id] = awarded_tracking_rewards[aspect_id].merge(tracking_update.awarded_tracking_rewards[aspect_id])
		else: 
			awarded_tracking_rewards[aspect_id] = tracking_update.awarded_tracking_rewards[aspect_id]

func to_dict():
	return {
		"updated_at": updated_at,
		"time_delta": time_delta,
		"awarded_tracking_rewards": Util.flatten_dict(awarded_tracking_rewards),
	}

func _to_string():
	return str(to_dict())
