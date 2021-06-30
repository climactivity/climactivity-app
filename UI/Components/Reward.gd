tool
extends RichTextLabel

export (Resource) var _reward setget set_reward

func _ready():
	if _reward != null:
		set_reward(_reward)

func set_reward(reward):
	if reward == null: 
		text = "Coins: 0 Xp: 0 Water: 0" 
		return
	_reward = reward
	
	# [img=36]res://Assets/Icons/coins-stack.png[/img] 500 [img=36]res://Assets/Icons/xp_star.png[/img] 1000
	var coins_str = ("[img=36]res://Assets/Icons/coins-stack.png[/img] %s " % str(_reward.coins) ) if _reward.get("coins") else ""
	var xp_str = ("[img=36]res://Assets/Icons/xp_star_w.png[/img] %s " % str(_reward.xp) ) if _reward.get("xp") else ""
	#var water_str = ("Water: %s" % str(_reward.water)) if _reward.get("water") else ""
	bbcode_text = "[center]" + coins_str + xp_str + "[/center]"  #+ water_str
