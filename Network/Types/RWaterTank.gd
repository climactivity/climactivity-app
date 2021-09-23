extends Resource
class_name RWaterTank
export (String) var for_aspect
export (float) var max_value = 100.0
export (float) var current_value
export (int) var last_used = 0

func add_water(water: float): 
	Logger.print("Added %2.4f water for %s" % [water, for_aspect], "RWaterTank")
	current_value = min(max_value, current_value + water)

func get_remaining_fill_time(fill_rate: float):
	if fill_rate == 0: return INF 
	return (max_value - current_value)/fill_rate
	
func to_dict():
	return {
		"for_aspect": for_aspect,
		"max_value": max_value,
		"current_value": current_value,
		"last_used": last_used
	}

func _to_string():
	return str(to_dict())

func initialize(aspect_id,run_time): 
	for_aspect = aspect_id
	max_value *= run_time
	last_used = OS.get_unix_time()
	
func get_water_amount():
	return current_value

func consume_water_amount(amount):
	last_used = OS.get_unix_time()
	var old_value = current_value 
	current_value -= amount
	if (old_value < amount):
		return old_value
	return amount

func reset(): 
	current_value = 0.0
