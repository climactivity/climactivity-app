extends Resource

export (int) var updated_at 
export (int) var time_delta

#{
#	[aspect_id]: {
#   	reward: RReward
#       apply_to: Board-Entity-ID
#   } 
#}
export (Dictionary) var awarded_tracking_rewards

func compact(date, interval):
	pass
