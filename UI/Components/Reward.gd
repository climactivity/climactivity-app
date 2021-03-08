tool
extends Label

export (Resource) var _reward setget set_reward

func _ready():
	if _reward != null:
		set_reward(_reward)

func set_reward(reward):
	_reward = reward
	text = "Coins: %d Xp: %d Water: %d" % [reward.coins,reward.xp,reward.water]
