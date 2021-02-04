extends Node

var bp_r_tracking_states = preload("res://Network/Types/RTrackingStates.gd") 
var bp_r_tracking_state = preload("res://Network/Types/RTrackingState.gd") 
var bp_r_tracking_entry = preload("res://Network/Types/RTrackingEntry.gd") 
var bp_r_reward = preload("res://Network/Types/RReward.gd") 
var bp_r_tracking_update = preload("res://Network/Types/RTrackingUpdate.gd")
var bp_r_water_tank = preload("res://Network/Types/RWaterTank.gd")
var tracking_states_path = "user://AspectTracking.tres"
var player_state = load(tracking_states_path)

#var last_update = OS.get_unix_time()
var interval = 60 * 60 * 2 # minutue * hour * 2 -> update every 2 hours

func _init():
	if player_state == null: 
		init_tacking_state()
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

func get_tracked_aspects(): 
	var out = []
	for aspect_id in player_state.tracking_states.keys(): 
		out.append(aspect_id)
	return out

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
