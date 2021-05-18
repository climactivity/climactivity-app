tool
extends Control
class_name RewardLabel

export (Resource) var _reward setget set_reward, get_reward

func set_reward(reward):
	_reward = reward

func get_reward():
	return _reward
	
func _display():
	pass
