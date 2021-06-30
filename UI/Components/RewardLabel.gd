tool
extends Control
class_name RewardLabel

export (Resource) var _reward setget set_reward, get_reward

var ready = false
onready var label = $MarginContainer/Label
func _ready():
	ready = true
	update()
	
func set_reward(reward):
	_reward = reward
	update()
func get_reward():
	return _reward
	
func update():
	if !ready:
		return
	if _reward != null and label != null:
		label.set_reward(_reward)
