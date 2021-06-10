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

# idk 
const MINUTE = 60
const HOUR = 60 * MINUTE
const DAY = 24 * HOUR
const WEEK = 7 * DAY

static func flatten_dict(dict):
	var out = {}
	for key in dict.keys():
		var res = dict.get(key)
		if(res is Dictionary):
			out[key] = Util.flatten_dict(res) 
		elif (res is Object and res.has_method("to_dict")):
			out[key] = res.to_dict() 
		else:
			out[key] = str(res)
	return out

static func flatten_array(arr):
	var out = []
	for res in arr:
		if res is Dictionary:
			out.push_back(res)
		elif (res.has_method("to_dict")):
			out.push_back(res.to_dict()) 
		else:
			out.push_back(str(res)) 
	return out

static func clear(node: Node):
	if node.get_child_count() == 0:
		return
	for child in node.get_children(): 
		node.remove_child(child)
		
static func change_callback(req: HTTPRequest, inst: Object, function: String):
	var current_request_callback 
	if req.get_signal_connection_list("request_completed") != []: 
		current_request_callback = req.get_signal_connection_list("request_completed")[0].method
		
	if (current_request_callback != null
		and req.is_connected("request_completed", inst, current_request_callback)):
		req.disconnect("request_completed", inst, current_request_callback)
	req.connect("request_completed", inst, function)

