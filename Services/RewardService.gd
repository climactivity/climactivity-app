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
	var old_level = inventory.level 
	var new_level = LevelLut.get_level(inventory.xp)
	inventory.level = new_level
	if new_level > old_level:
		_show_levelup_popup(new_level,old_level)

var levelup_popup = preload("res://UI/LevelUpPopup.tscn")

func _show_levelup_popup(new_level, old_level):
	var _lu_popup_inst = levelup_popup.instance()
	_lu_popup_inst.set_level_up_to(new_level)
	GameManager.overlay._show_popup(_lu_popup_inst)
	
func pay_coins(amount): 
	if player_state.inventory.coins >= amount: 
		var old_coins = player_state.inventory.coins
		var reward = RReward.new()
		reward.xp = 0
		reward.coins = -amount
		add_reward(reward)
		NakamaConnection.wallet_update(amount, player_state.inventory.coins, old_coins)
		return true
	else: 
		return false
