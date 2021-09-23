extends Resource
class_name RTrackingState
export (String) var bigpoint
export (String) var aspect
export (Resource) var current
export (Array) var history
export (Resource) var water_tank
export (int) var run_time # in days
export (Resource) var current_entity
export (Array) var entity_list
export (bool) var new_seedling_available = false

func _init(data = {}):
	var dict = {}
	if data is String: 
		var json = JSON.parse(data)
		if json.error:
			Logger.error("invald json: %s" % str(json.error)) 
			return null
		dict = json.result
	else:
		dict = data
	if dict is Dictionary and dict != {}:
		from_dict(dict)


func from_dict(dict): 
	bigpoint = dict["bigpoint"] if dict.has("bigpoint") else "" # p_bigpoint
	aspect = dict["aspect"] if dict.has("aspect") else "" # p_bigpoint
	run_time = dict["run_time"] if dict.has("run_time") else 0 # p_bigpoint
	new_seedling_available = dict["new_seedling_available"] if dict.has("new_seedling_available") else false # p_bigpoint

func get_water_for_time_interval_from_now(seconds) -> Resource:
	if current == null:
		return null
	var current_state_since = OS.get_unix_time() - current.time_stamp
	if seconds <= current_state_since:	
		return current.get_water_from_factor(seconds)
	else: 
		var water = null
		var remaining = seconds
		var last_time_stamp = OS.get_unix_time()
		for entry in history: 
			var applied_time =  last_time_stamp - entry.time_stamp
			var current_water =  entry.get_water_from_factor(min(applied_time, remaining))
			remaining -= applied_time
			if water == null:
				water = current_water
			else:
				water = water + current_water
			if remaining <= 0: 
				break
		return water

func _get_water_for_time_interval(start, end): 
	var seconds = end - start
	if current == null:
		return null
	var current_state_since = end - current.time_stamp
	if seconds <= current_state_since:
		return current.get_water_from_factor(seconds)
	else: 
		var water = null
		var remaining = seconds
		var last_time_stamp = end
		for entry in history: 
			var applied_time =  last_time_stamp - entry.time_stamp
			var current_water =  entry.get_water_from_factor(min(applied_time, remaining))
			remaining -= applied_time
			if water == null:
				water = current_water
			else:
				water = water + current_water
			if remaining <= 0: 
				break
		return water

func get_next_growth_period(): 
	var next_entity_count = entity_list.size()
	
	match(next_entity_count):
		0:
			return 1 * Util.DAY
		1: 
			return 2  * Util.DAY
		2:
			return 4 * Util.DAY
		_:
			return 7 * Util.DAY

#func get_water_for_time_interval_from_now(seconds) -> float:
#	var current_state_since = OS.get_unix_time() - current.time_stamp
#	if seconds <= current_state_since:	
#		return current.get_reward_for_time_interval(seconds)
#	else: 
#		var reward = null
#		var remaining = seconds
#		var last_time_stamp = OS.get_unix_time()
#		for entry in history: 
#			var applied_time =  last_time_stamp - entry.time_stamp
#			var current_reward =  entry.get_reward_for_time_interval(min(applied_time, remaining))
#			remaining -= applied_time
#			if reward == null:
#				reward = current_reward
#			else:
#				reward.merge(current_reward)
#			if remaining <= 0: 
#				break
#		return reward
#

# cannot go into _init() because resources need to have a no args constructor to deserialize properly
func make_tracking_state(new_bigpoint, new_aspect, new_entry, new_run_time): 
	bigpoint = new_bigpoint
	aspect = new_aspect
	history = []
	history.push_front(new_entry)
	current = new_entry
	run_time = new_run_time
	# TODO make water tank
	if current_entity == null: 
		new_seedling_available = true


func _to_string():
	return str(to_dict())

func to_dict(): 
	var out = {

	  "bigpoint" : bigpoint,
	  "aspect" : aspect,
	  "current" : current.to_dict() if current != null else "null",
	  "history" : Util.flatten_array(history),
	  "water_tank" : water_tank,
	  "run_time" : run_time, # in days
	}
	#Logger.print(out)
	return out


func get_water_available():
	if water_tank == null: return 0.0
	return water_tank.get_water_amount()

func add_starter_water():
	if water_tank == null: return 0.0
	return water_tank.add_water(50.0)

func get_water_percent_available(): 
	return water_tank.get_water_amount() / water_tank.max_value

func get_water_tank_size(): 
	return water_tank.max_value

func _empty_water_tank():
	water_tank.reset()

func get_aspect_data():
	return Api.get_aspect_by_name(aspect)

func add_entity(entity): 
	current_entity = entity
	entity_list.append(current_entity)

func get_current_entity(): 
	if current_entity != null: 
		return current_entity
	else:
		if is_instance_valid(Logger): Logger.print("No current active entity for %s:%s" % [aspect, bigpoint], self)

func should_place_new_entity(): 
	if _has_legacy_water(): 
		return false
	return current_entity == null or current_entity.is_mature()

func apply_water(entity = null): 
	if entity == null:
		entity = current_entity
	var current_water = get_water_available()
	if entity.has_method("consume_water"): 
		var water_period_start = water_tank.last_used if entity.planted_at < water_tank.last_used else entity.planted_at
		var water_period_end = OS.get_unix_time() if entity == current_entity else entity.matured_at()
		var entity_water_amount_wanted = _get_water_for_time_interval(water_period_start, water_period_end)
		var entity_water_amount = water_tank.consume_water_amount(entity_water_amount_wanted)
		entity.consume_water(entity_water_amount)
	
func show_waiting_for_water(): 
	if current_entity != null and current_entity.has_method("alert_can_water"): 
		current_entity.alert_can_water() 
	if _has_legacy_water(): 
		var _work_copy = [] + entity_list # cool array cloning
		var _legacy_entity = _work_copy.pop_back()
		while _legacy_entity != null and _legacy_entity.planted_at >= water_tank.last_used:
			if _legacy_entity.has_method("alert_can_water"):
				_legacy_entity.alert_can_water()
			_legacy_entity = _work_copy.pop_back()


func _has_legacy_water(): 
	if current_entity == null: 
		if entity_list.size() > 0: 
			return entity_list.back().matured_at() <= water_tank.last_used
		else:
			return false
	return current_entity.planted_at >= water_tank.last_used
