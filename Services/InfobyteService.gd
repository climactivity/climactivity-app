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
