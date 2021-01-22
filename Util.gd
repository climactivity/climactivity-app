extends Node

static func map_to_range(x,a,b,c,d): 
	return (x-a)/(b-a) * (d-c) + c

const uuid_util = preload('res://uuid.gd')

static func update_dict_with(old_dict: Dictionary, update_dict: Dictionary) -> Dictionary:
	var new_dict = old_dict
	for key in update_dict.keys(): 
		new_dict[key] = update_dict.get(key)
	return new_dict
