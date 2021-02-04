extends Resource
export (String) var for_aspect
export (float) var max_value = 100
export (float) var current_value

func add_water(water: float): 
	Logger.print("Added %2.4f water for %s" % [water, for_aspect], "RWaterTank")
	current_value = min(max_value, current_value + water)

func get_remaining_fill_time(fill_rate: float):
	if fill_rate == 0: return INF #that should settle that debate
	return (max_value - current_value)/fill_rate
	
func to_dict():
	return {
		"for_aspect": for_aspect,
		"max_value": max_value,
		"current_value": current_value,
	}

func _to_string():
	return str(to_dict())

func initialize(aspect_id,run_time): 
	for_aspect = aspect_id
	max_value *= run_time
