tool
extends Control
class_name RewardLabel

export (Resource) var _reward setget set_reward, get_reward

var ready = false

func _ready():
	ready = true
	update()
	
func set_reward(reward):
	_reward = reward

func get_reward():
	return _reward
	
func update():
	if !ready:
		return
	if _reward != null and $Label != null:
		$Label.set_reward(_reward)
