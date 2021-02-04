extends Resource

export (Dictionary) var tracking_states = {}
export (Array) var tracking_updates = []
export (int) var last_update = 0
export (Dictionary) var board_entites = {}
export (Dictionary) var inventory = {}
export (Dictionary) var level = {}

func from_dict(dict): 
	Logger.error("from_dict not impemented!", self)
	pass

func to_dict(): 
	var out = {
		"tracking_states": Util.flatten_dict(tracking_states),
		"tracking_updates": Util.flatten_array(tracking_updates),
		"last_update": last_update,
		"board_entites": Util.flatten_dict(board_entites),
		"inventory": Util.flatten_dict(inventory),
		"level": Util.flatten_dict(level)
	}
	#Logger.print(out)
	return out

func compact_updates(date, interval):
	pass

func to_json():
	return JSON.print(to_dict())

func _to_string():
	return JSON.print(to_dict())

