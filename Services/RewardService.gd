extends Node
var reward = preload("res://Network/Types/RReward.gd")
var player_state 

signal reward_added(reward)

func _ready(): 
	player_state = PSS.get_player_state_ref()
	
func add_reward(reward, show = false):
	player_state.add_reward(reward)
	if show: emit_signal("reward_added", reward)

func DEBUG_default_reward():
	Logger.print("Generated default reward", self)
	return reward.new()
