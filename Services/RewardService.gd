extends Node

var player_state 

func _ready(): 
	player_state = PSS.get_player_state_ref()
	
func add_reward(reward):
	player_state.add_reward(reward)
