extends Node

signal loaded(newGame)

var bp_r_tracking_states = preload("res://Network/Types/RTrackingStates.gd") 

var player_state_path = "user://AspectTracking"
var player_state_format = ".tres"
var player_state_qualifyed_path = "%s%s" % [player_state_path, player_state_format]
var player_state = null

var flush_on = [NOTIFICATION_APP_PAUSED]
var is_first_run = "loading"


func _init(): 
	var check_file = File.new()
	if check_file.file_exists(player_state_qualifyed_path):
		
		player_state = ResourceLoader.load(player_state_qualifyed_path)
		if player_state == null: 
			init_player_state()
		else: 
			is_first_run = false
			emit_signal("loaded", false)
			Logger.print("loaded save data", "PSS")
	else: 
		init_player_state() 


func flush():
	ResourceSaver.save(player_state_qualifyed_path, player_state)
	_sync()

func reset_game_state(): 
	init_player_state()
	Api.cache.drop_cache()
	DialogicSingleton.init(true)
	
func get_player_state_as_dict(): 
	return player_state.to_dict()

func get_player_state_ref() -> RTrackingStates:
	return player_state

func init_player_state():
	Logger.print("creating new save game", "PSS")
	is_first_run = true
	player_state = bp_r_tracking_states.new()
	player_state.take_over_path(player_state_qualifyed_path)
	#flush()
	emit_signal("loaded", true)
func _sync(): 
#	Api.sync_player_state()
	if NakamaConnection: NakamaConnection.sync_player_state(player_state) 

func update_from_json(document): 
	pass

func add_item_to_inventory(entity):
	player_state.inventory.add_item(entity)
	flush()
func _notification(what):
	## TODO flush when engine is about to shut down?
	if flush_on.find(what) != -1: 
		flush() 
