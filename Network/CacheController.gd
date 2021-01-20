extends Node

const aspect_resource_type = preload("res://Network/Types/RLocalizedAspectData.gd") 

var err = OK

onready var req = $HTTPRequest

func update():
	$HTTPRequest.connect("request_completed", self, "_on_update_aspects")
	Api.getEndpoint("cache-aspects", req, [], true)
	

func _on_update_aspects(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		print("Server error: ", json.error)
	else:
		$HTTPRequest.disconnect("request_completed", self, "_on_update_aspects")
		$HTTPRequest.connect("request_completed", self, "_on_update_info")
		Api.getEndpoint("quiz_list", req, [], true)
		_save_aspect_data(json.result)

func _save_aspect_data(data):

	for aspect_data in data: 
		Logger.print("Saving resource for %s" % aspect_data["name"], self)
		var aspect_resource = aspect_resource_type.new(
			aspect_data["bigpoint"], # p_bigpoint
			aspect_data["name"], # p_name = "",
			aspect_data["title"], # p_title = "",
			aspect_data["forLanguage"], # p_language = "DE",
			aspect_data["forRegion"], # p_region = "DE",
			aspect_data["message"], # p_message = "",
			aspect_data["localizedTrackingData"], # p_tracking = {},
			aspect_data["infoGraph"] # p_info_graph = {}
		)
		ResourceSaver.save("res://Network/Cache/Aspects/%s.res" % aspect_data["name"], aspect_resource, 32)

func _on_update_info(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		print("Server error: ", json.error)
	else:
		print("info")
