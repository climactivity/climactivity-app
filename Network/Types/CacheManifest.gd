extends Resource

export (int) var last_update # unix_time
export (String) var lang = "DE"
export (String) var region = "DE"
export (Dictionary) var saved_entities 

func _init(time = null):
	if (time == null): return
	else: last_update = OS.get_unix_time()

func insert(_id, type):
	saved_entities[_id] = {"type": type, "updated": OS.get_unix_time()}
	last_update = OS.get_unix_time()
