extends Resource

export (Resource) var for_aspect
export (float) var max_value
export (float) var current_value

func add_water(water: float): 
	current_value = min(max_value, current_value + water)

func get_remaining_fill_time(fill_rate: float):
	if fill_rate == 0: return INF #that should settle that debate
	return (max_value - current_value)/fill_rate
