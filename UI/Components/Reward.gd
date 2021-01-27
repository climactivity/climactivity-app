tool
extends Label

func set_reward(reward):
	text = "Coins: %d Xp: %d Water: %d" % [reward.coins,reward.xp,reward.water]
