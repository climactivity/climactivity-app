extends Node

var completed_infobytes = PSS.get_player_state_ref().completed_infobytes

func _ready():
	if completed_infobytes == null:
		completed_infobytes = {}
		flush()

func is_completed(infobyte_id): 
	if completed_infobytes.has(infobyte_id):
		return  completed_infobytes.get(infobyte_id)
	else:
		return false

func get_factor_completion(factor, aspect):
	var infobytes = Api.get_infobytes_for_factor(factor, aspect)
	var num_complete = 0.0
	if infobytes.size() == 0: 
		return 0.0
	for infobyte in infobytes:
		if is_completed(infobyte._id):
			num_complete += 1.0
	return num_complete / float(infobytes.size())
func complete_infobyte(infobyte_id, instigator = null , callback: String = ""):
	completed_infobytes[infobyte_id] = {
		"completed_at": OS.get_unix_time()
	}
	flush()
	if instigator != null and callback != "": 
		instigator.call(callback)
	return true 

func flush():
	PSS.flush()

func get_aspect_infobyte_completion(aspect): 
	var completion = 0.0
	for factor in aspect.factors: 
		completion += get_factor_completion(factor, aspect)
	return completion / float(aspect.factors.size())
