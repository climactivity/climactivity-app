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

func to_dict(dict): 
	Logger.error("to_dict not impemented!", self)
	pass
