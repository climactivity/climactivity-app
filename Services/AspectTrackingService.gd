extends Node

var bp_r_tracking_states = preload("res://Network/Types/RTrackingStates.gd") 
var bp_r_tracking_state = preload("res://Network/Types/RTrackingState.gd") 
var bp_r_tracking_entry = preload("res://Network/Types/RTrackingEntry.gd") 
var bp_r_reward = preload("res://Network/Types/RReward.gd") 
var tracking_states_path = "user://AspectTracking.tres"
var player_state = load(tracking_states_path)

var last_update = OS.get_unix_time()
var interval = 60 * 60 * 2 # minutue * hour * 2 -> update every 2 hours

func _init():
	if player_state == null: 
		init_tacking_state()
	if OS.is_debug_build(): 
		interval = 60 # update every minute in debug builds

func _process(delta):
	if OS.get_unix_time() - last_update > interval:
		var now = OS.get_unix_time() 
		do_update(now, last_update, OS.get_unix_time() - last_update, delta) 
		last_update = OS.get_unix_time()

func do_update(now, last_update, absolute_delta, frame_delta): 
	Logger.print(
		"Aspect tracking update at %s, last update %s, update delta %s, frame time %s"
		% [
			str(OS.get_datetime_from_unix_time(now)),
			str(OS.get_datetime_from_unix_time(last_update)),
			str(absolute_delta),
			str(frame_delta)
		], self)

func commit_tracking_level(option, aspect): 
	Logger.print("Commit %s for aspect %s" % [option["level"], aspect._id], self)
	var new_reward = bp_r_reward.new()
	new_reward._id = "-1"
	new_reward.coins = option["reward"]["coins"]
	new_reward.xp = option["reward"]["xp"]	
	new_reward.water = option["reward"]["water"]
	var new_entry = bp_r_tracking_entry.new()
	new_entry.aspect = aspect._id
	new_entry.time_stamp = OS.get_unix_time()
	new_entry.level = option["level"] if option.has("level") else 0 
	new_entry.value = option["value"] if option.has("value") else -1 
	new_entry.reward = new_reward
	if player_state.tracking_states.has(aspect._id): 
		if player_state.tracking_states[aspect._id].history == null: 
			player_state.tracking_states[aspect._id].history = []
		player_state.tracking_states[aspect._id].history.push_front(new_entry)
		player_state.tracking_states[aspect._id].current = new_entry
	else:
		var new_state = bp_r_tracking_state.new()
		new_state.bigpoint = aspect["bigpoint"]
		new_state.aspect = aspect["_id"]
		var  history = []
		history.push_front(new_entry)
		new_state.history = history
		new_state.current = new_entry
		player_state.tracking_states[aspect._id] = new_state
	_flush()

func get_current_tracking_level(aspect): 
	var id
	if aspect is String: 
		id = aspect
	else:
		id = aspect._id
	if player_state.tracking_states.has(id):
		return player_state.tracking_states[id].current
	else: 
		return null

func init_tacking_state():
	player_state = bp_r_tracking_states.new()
	player_state.take_over_path(tracking_states_path)
	_flush()

func _flush(): 
	ResourceSaver.save(tracking_states_path, player_state)
