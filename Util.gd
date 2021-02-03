extends Node

static func map_to_range(x,a,b,c,d): 
	return (x-a)/(b-a) * (d-c) + c

const uuid_util = preload('res://uuid.gd')

static func update_dict_with(old_dict: Dictionary, update_dict: Dictionary) -> Dictionary:
	var new_dict = old_dict
	for key in update_dict.keys(): 
		new_dict[key] = update_dict.get(key)
	return new_dict

static func date_as_RFC1123(date_time):
	var nameweekday= ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var namemonth= ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var dayofweek = date_time["weekday"]   # from 0 to 6 --> Sunday to Saturday
	var day = date_time["day"]                         #   1-31
	var month= date_time["month"]               #   1-12
	var year= date_time["year"]             
	var hour= date_time["hour"]                     #   0-23
	var minute= date_time["minute"]             #   0-59
	var second= date_time["second"]             #   0-59
	return "%s, %02d %s %d %02d:%02d:%02d GMT" % [nameweekday[dayofweek], day, namemonth[month-1], year, hour, minute, second]
