extends Node

const aspect_resource_type = preload("res://Network/Types/RLocalizedAspectData.gd") 

var err = OK
#var fs = "res" if Engine.is_editor_hint() else "user" 
var fs = "user"
onready var req = $HTTPRequest

func update():
	Logger.print("Rebuilding Cache...", self)
	_make_dirs()
	$HTTPRequest.connect("request_completed", self, "_on_update_aspects")
	Api.getEndpoint("cache-aspects", req, [], true)


func _make_dirs(): 
	var dirs = ["Aspects", "Infobytes", "Quests"]
	var dir = Directory.new()
	if fs == "user":
		for d in dirs:
			dir.make_dir_recursive("user://Network/Cache/%s" % d)
	else:
		if(dir.open("res://Network/Cache")):
			for d in dirs:
				dir.make_dir(d)


func _on_update_aspects(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		print("Server error: ", json.error)
	else:
		_save_aspect_data(json.result)
		$HTTPRequest.disconnect("request_completed", self, "_on_update_aspects")
		$HTTPRequest.connect("request_completed", self, "_on_update_info")
		Api.getEndpoint("quiz_list", req, [], true)


func _save_aspect_data(data):
	for aspect_data in data: 
		var path = fs + "://Network/Cache/Aspects/%s.res" % aspect_data["name"]
		Logger.print("Saving resource for %s at %s" % [aspect_data["name"], path ], self)
		var aspect_resource = aspect_resource_type.new(
			aspect_data["bigpoint"] if aspect_data.has("bigpoint") else "", # p_bigpoint
			aspect_data["name"] if aspect_data.has("name") else "", # p_name = "",
			aspect_data["title"] if aspect_data.has("title") else "", # p_title = "",
			aspect_data["forLanguage"] if aspect_data.has("forLanguage") else "", # p_language = "DE",
			aspect_data["forRegion"] if aspect_data.has("forRegion") else "", # p_region = "DE",
			aspect_data["message"] if aspect_data.has("message") else "", # p_message = "",
			aspect_data["localizedTrackingData"] if aspect_data.has("localizedTrackingData") else {}, # p_tracking = {},
			aspect_data["infoGraph"] if aspect_data.has("infoGraph") else {} # p_info_graph = {}
		)
		ResourceSaver.save(path, aspect_resource, 32)

func _on_update_info(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		print("Server error: ", json.error)
	else:
		print("info")
		_done()
		
func _done(): 
	get_parent().emit_signal("finished_cache")
