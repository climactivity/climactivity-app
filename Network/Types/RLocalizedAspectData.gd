extends Resource

class_name RLocalizedAspectData

export (String) var bigpoint
export (String) var type
export (String) var name
export (String) var _id
export (String) var title
export (String) var language
export (String) var region
export (String) var message
export (Dictionary) var tracking # tracking options show reward for one day (which is how long the first board entity is active), later entities are active for longer and the ui should reflect that
export (Dictionary) var info_graph
export (Array) var factors
export (Texture) var icon

func _init(dict = {}):
	#if (dict == null): return
	bigpoint = dict["bigpoint"] if dict.has("bigpoint") else "" # p_bigpoint
	_id = dict["_id"] if dict.has("_id") else ""
	name = dict["name"] if dict.has("name") else "" # p_name = "",
	title = dict["title"] if dict.has("title") else "" # p_title = "",
	language = dict["forLanguage"] if dict.has("forLanguage") else "" # p_language = "DE",
	region = dict["forRegion"] if dict.has("forRegion") else "" # p_region = "DE",
	message = dict["message"] if dict.has("message") else "" # p_message = "",
	tracking = dict["localizedTrackingData"] if dict.has("localizedTrackingData") else {} # p_tracking = {},
	info_graph = dict["infoGraph"] if dict.has("infoGraph") else {} # p_info_graph = {}
	factors = dict["localizedFactors"] if dict.has("localizedFactors") else []
	icon = dict["icon"] if dict.has("icon") else null
	type = dict["archetype"] if dict.has("archetype") else 'tree'
	
func get_option_for_level(level): 
	if tracking == {}: return null
	if tracking.has("options"):
		var options = tracking.get("options")
		if options is Array:
			if options.size() > level as int:
				return options[level as int]
	return null
