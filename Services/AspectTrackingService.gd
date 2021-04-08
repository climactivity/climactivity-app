extends Node

signal tracking_updated

var bp_r_tracking_states = preload("res://Network/Types/RTrackingStates.gd") 
var bp_r_tracking_state = preload("res://Network/Types/RTrackingState.gd") 
var bp_r_tracking_entry = preload("res://Network/Types/RTrackingEntry.gd") 
var bp_r_reward = preload("res://Network/Types/RReward.gd") 
var bp_r_tracking_update = preload("res://Network/Types/RTrackingUpdate.gd")
var bp_r_water_tank = preload("res://Network/Types/RWaterTank.gd")
var tracking_states_path = "user://AspectTracking.tres"
var player_state 

#var last_update = OS.get_unix_time()
var interval = 60 * 60 * 2 # minutue * hour * 2 -> update every 2 hours
var water_collected_for = []
func _init():
	player_state = PSS.get_player_state_ref()
	if OS.is_debug_build(): 
		interval = 60 # update every minute in debug builds

func _ready():
	if Api.is_cache_ready(): # don't update if aspects aren't loaded yet, it might cause problems
		do_update()
	Api.connect("cache_ready", self, "do_update") # update when cache changes to get updates to rewards as quickly as possible
	
func _process(delta):
	if OS.get_unix_time() - player_state.last_update >= interval:
		var now = OS.get_unix_time() 
		do_update() 


# update all tracked aspects with current rewards based on tracking level and passed time
# should be invariant to call rate 
func do_update(): 
	var now = OS.get_unix_time()
	var last_update = player_state.last_update
	var absolute_delta = OS.get_unix_time() - player_state.last_update
	# handle initialization of player state when no updates have happended yet 
	var levels = player_state.tracking_states
	# break if no aspects are tracked or the app is started for the first time
	if player_state.last_update == 0 or levels.size() == 0: 
		# just set the current time when the app is first started
		# there cannot be anything to track yet
		player_state.last_update = OS.get_unix_time()
		Logger.print("Aspect tracking initialized at %s!" % Util.date_as_RFC1123(OS.get_datetime_from_unix_time(now)), self)
		_flush()
		return
	Logger.print(
		"Aspect tracking update at %s, last update %s, update delta %ss"
		% [
			Util.date_as_RFC1123(OS.get_datetime_from_unix_time(now)),
			Util.date_as_RFC1123(OS.get_datetime_from_unix_time(last_update)),
			str(absolute_delta)
		], self)			
	var tracking_update = bp_r_tracking_update.new()
	tracking_update.set_time(now, absolute_delta)
	var total_reward = bp_r_reward.new()
	for aspect_id in levels: 
		var tracking_state = levels[aspect_id]
		var reward = tracking_state.get_reward_for_time_interval_from_now(absolute_delta)
		if tracking_state.water_tank == null:
			tracking_state.water_tank = bp_r_water_tank.new()
			tracking_state.water_tank.initialize(aspect_id, tracking_state.run_time)
			#tracking_state.water_tank.add_water(100.0)
		tracking_state.water_tank.add_water(reward.water)
		# add update to stats
		tracking_update.add_reward(aspect_id, reward)
		total_reward.merge(reward)
	player_state.add_tracking_update(tracking_update, total_reward)
	#finalize
	player_state.last_update = OS.get_unix_time()
	#Logger.print(player_state.to_json(), self)
	_flush()
	Api.push_tracking_state(player_state)
	emit_signal("tracking_updated")

func get_tracked_aspects(): 
	var out = []
	for aspect_id in player_state.tracking_states.keys(): 
		out.append(aspect_id)
	return out

# TODO move construction logic to builder methods
func commit_tracking_level(option, aspect): 
	Logger.print("Commit %s for aspect %s" % [option["level"], aspect._id], self)
	var new_reward = bp_r_reward.new()
	new_reward._id = "-1"
	new_reward.coins = option["reward"]["coins"]
	if option["reward"].has("xp"):
		new_reward.xp = option["reward"]["xp"]
	else:
		new_reward.xp = 0.0
	new_reward.water =  option["reward"]["water"]
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
		new_state.make_tracking_state(aspect["bigpoint"], aspect["_id"], new_entry, 1)
#		new_state.bigpoint = aspect["bigpoint"]
#		new_state.aspect = aspect["_id"]
#		new_state.run_time = 1
#		var  history = []
#		history.push_front(new_entry)
#		new_state.history = history
#		new_state.current = new_entry
		player_state.tracking_states[aspect._id] = new_state
	_flush()

func get_tracking_state(aspect):
	var id
	if aspect is String: 
		id = aspect
	else:
		id = aspect._id
	if player_state.tracking_states.has(id):
		return player_state.tracking_states[id]
	else: 
		return null

func has_seedling_available(aspect):
	var current_state = get_tracking_state(aspect)
	if current_state != null: 
		return current_state.new_seedling_available
	else: 
		return false

func award_seedling(aspect): 
	var current_state = get_tracking_state(aspect)
	if current_state != null: 
		current_state.new_seedling_available = true

func consume_seedling(aspect_id, entity): 
	if has_seedling_available(aspect_id) or ProjectSettings.get_setting("debug/settings/game_logic/cheat_seedlings"):
		var current_state = player_state.tracking_states[aspect_id]
		current_state.new_seedling_available = false
		current_state.add_entity(entity)
		do_update()
		#current_state.new_seedling_available = false
		_flush()
		return true
	return false

func get_current_tracking_level(aspect): 
	var current_state = get_tracking_state(aspect)
	if current_state != null: 
		return current_state.current
	else: 
		return null

func has_water_available(): 
	var has_water = 0.0
	for tracking_state_key in player_state.tracking_states: 
		var tracking_state = player_state.tracking_states[tracking_state_key]
		has_water += tracking_state.get_water_available()
	return has_water > 0

func get_tracked_aspects_for_sector(sector): 
	var sector_name
	if sector is String:
		sector_name = sector
	else:
		sector_name = sector.sector
	var aspects = []
	for tracking_state_key in player_state.tracking_states: 
		var tracking_state = player_state.tracking_states[tracking_state_key]
		if tracking_state.bigpoint == sector_name:
			aspects.append(tracking_state)
	return aspects

func get_total_water_for_sector(sector):
	# TODO
	var aspect_data = get_tracked_aspects_for_sector(sector)
	var total
	pass

func water_collected(aspect): 
	water_collected_for.append(aspect)

func get_water_collected(): 
	return  water_collected_for

func water_used(aspect):
	for tracking_state in water_collected_for:
		if tracking_state.aspect == aspect._id:
			water_collected_for.erase(tracking_state)
			tracking_state.apply_water()
	emit_signal("tracking_updated")
	_flush()
			
func water_used_for(entity_id):
	#_get_tracking_state_for
	pass
func notify_watered_aspects():
	for aspect_tracking_state in water_collected_for: 
		aspect_tracking_state.show_waiting_for_water()

func _flush(): 
	PSS.flush()
