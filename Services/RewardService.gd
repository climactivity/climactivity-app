extends Node
var reward = preload("res://Network/Types/RReward.gd")
var player_state 

signal reward_added(reward)
signal xp_bar_update
func _ready(): 
	player_state = PSS.get_player_state_ref()
	update_xp_vals()
func add_reward(reward, show = false):
	if reward == null:
		reward = DEBUG_default_reward()
	player_state.add_reward(reward)
	update_xp_vals()
	if show: emit_signal("reward_added", reward)
	PSS.flush()
	emit_signal("xp_bar_update")
func DEBUG_default_reward():
	Logger.print("Generated default reward", self)
	var r =  reward.new()
	r.coins = 20
	r.xp = 200
	return r

func level_frag(xp):
	return 100.0 * LevelLut.get_frac(xp)
#	return 100.0*fmod(xp, 500)/500

func update_xp_vals(): 
	var inventory = player_state.inventory
	inventory.level = LevelLut.get_level(inventory.xp)
	
