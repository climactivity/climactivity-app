extends Resource

export (int) var last_update # unix_time
export (String) var lang = "DE"
export (String) var region = "DE"
export (Dictionary) var saved_entities 

func _init(time = null):
	if (time == null): return
	else: update_timestamp()

func insert(_id, type, fs = "user"):
	saved_entities[_id] = {"type": type, "updated": OS.get_unix_time(), "where": fs }
	update_timestamp()

func update(new_entities, update): 
	last_update = update
	saved_entities = Util.update_dict_with(saved_entities,new_entities)

func update_timestamp():
	last_update = OS.get_unix_time()
