tool
extends Label

export (Resource) var _reward setget set_reward

func _ready():
	if _reward != null:
		set_reward(_reward)

func set_reward(reward):
	if reward == null: 
		text = "Coins: 0 Xp: 0 Water: 0" 
		return
	_reward = reward
	var coins_str = ("Coins: %s " % str(_reward.coins) ) if _reward.get("coins") else ""
	var xp_str = ("Xp: %s " % str(_reward.xp) ) if _reward.get("xp") else ""
	var water_str = ("Water: %s" % str(_reward.water)) if _reward.get("water") else ""
	text = coins_str + xp_str  + water_str
