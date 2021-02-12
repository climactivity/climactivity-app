extends Node

var bp_r_tracking_states = preload("res://Network/Types/RTrackingStates.gd") 

var player_state_path = "user://AspectTracking"
var player_state_format = ".tres"
var player_state_qualifyed_path = "%s%s" % [player_state_path, player_state_format]
var player_state = load(player_state_qualifyed_path)

var flush_on = [NOTIFICATION_APP_PAUSED]

func _init(): 
	if player_state == null: 
		init_player_state()

func flush():
	ResourceSaver.save(player_state_qualifyed_path, player_state)

func get_player_state_ref():
	return player_state

func init_player_state():
	player_state = bp_r_tracking_states.new()
	player_state.take_over_path(player_state_qualifyed_path)
	flush()
	
func _sync(): 
	Api.sync_player_state() 

func update_from_json(document): 
	pass

func add_item_to_inventory(entity):
	player_state.inventory.add_item(entity)

func _notification(what):
	## TODO flush when engine is about to shut down?
	if flush_on.find(what) != -1: 
		flush() 
