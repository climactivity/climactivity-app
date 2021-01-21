extends Node

const aspect_resource_type = preload("res://Network/Types/RLocalizedAspectData.gd") 
const bp_cache_manifest = preload("res://Network/Types/CacheManifest.gd")

var fixed_cache_manifest = load("res://Network/Cache/manifest.res")
var dynamic_cache_manifest = load("user://Network/Cache/manifest.res")
var writealbe_cache_manifest
var err = OK
var fs = "user" 
var res_writable = false
onready var req = $HTTPRequest

func update():
	res_writable = OS.is_debug_build()
	
	if (res_writable):
		fs = "res"
		writealbe_cache_manifest = fixed_cache_manifest
	Logger.print("Rebuilding Cache...", self)
	_make_dirs()
	_make_manifest()
	$HTTPRequest.connect("request_completed", self, "_on_update_aspects")
	Api.getEndpoint("cache-aspects", req, [], true)


func _make_dirs(): 
	var dirs = ["Aspects", "Infobytes", "Quests", "TreeTemplates"]
	var dir = Directory.new()
	if fs == "user":
		for d in dirs:
			dir.make_dir_recursive("user://Network/Cache/%s" % d)
	else:
		if(dir.open("res://Network/Cache")):
			for d in dirs:
				dir.make_dir(d)

func _make_manifest(): 
	if(dynamic_cache_manifest == null): 
		dynamic_cache_manifest = bp_cache_manifest.new()
	writealbe_cache_manifest = dynamic_cache_manifest
	if (res_writable):
		if(fixed_cache_manifest == null): 
			fixed_cache_manifest = bp_cache_manifest.new()
		writealbe_cache_manifest = fixed_cache_manifest

func _get_updated_resource_list(): 
	pass
func _check_manifest(): 
	pass


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
		var aspect_resource = aspect_resource_type.new(aspect_data)
		writealbe_cache_manifest.insert(aspect_data["_id"], "RLocalizedAspect")
		ResourceSaver.save(path, aspect_resource, 32)

func _on_update_info(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		print("Server error: ", json.error)
	else:
		print("info")
		_done()
		
func _done(): 
	var path = fs + "://Network/Cache/manifest.res"
	ResourceSaver.save(path, writealbe_cache_manifest, 32)
	get_parent().emit_signal("finished_cache")
