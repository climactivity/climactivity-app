extends Node

const aspect_resource_type = preload("res://Network/Types/RLocalizedAspectData.gd") 
const infobyte_resource_type = preload("res://Network/Types/InfoBytes/RInfoByte.gd")
const tree_template_resource_type = preload("res://Network/Types/RTreeTemplate.gd") 
const bp_cache_manifest = preload("res://Network/Types/CacheManifest.gd")

const type_map = {
	"RLocalizedAspect": "Network/Cache/Aspects",
	"RLocalizedInfobyte": "Network/Cache/Infobytes",
	"RTreeTemplate" : "Network/Cache/TreeTemplates" 
}

var fixed_cache_manifest 
var dynamic_cache_manifest
var writalbe_cache_manifest
var err = OK
var fs = "user" 
var res_writable = false
var current_request_callback = null
var format = "tres"

var entities = {}
var is_ready = false setget , is_ready
onready var req = $HTTPRequest

func _res_writable(): 
	var file = File.new()
	var err = file.open("res://Network/Cache/.is_writable", File.WRITE)
	return err == OK
	
func update():
	res_writable = _res_writable()
	if (res_writable):
		fs = "res"
		writalbe_cache_manifest = fixed_cache_manifest
	Logger.print("Rebuilding Cache...", self)
	_make_dirs()
	_make_manifest()
	_load_manifest_resources()
	_get_updated_resource_list()

func change_callback(function):
	if (current_request_callback != null
		and $HTTPRequest.is_connected("request_completed", self, current_request_callback)):
		$HTTPRequest.disconnect("request_completed", self, current_request_callback)
	$HTTPRequest.connect("request_completed", self, function)
	current_request_callback = function

func _make_dirs(): 
	var dirs = ["Aspects", "Infobytes", "Quests", "TreeTemplates"]
	var dir = Directory.new()
	for d in dirs:
		dir.make_dir_recursive("%s://Network/Cache/%s" % [fs,d])

func _make_manifest(): 
	fixed_cache_manifest = load("res://Network/Cache/manifest.tres")
	dynamic_cache_manifest = load("user://Network/Cache/manifest.tres")
	if(dynamic_cache_manifest == null): 
		dynamic_cache_manifest = bp_cache_manifest.new()
	writalbe_cache_manifest = dynamic_cache_manifest
	if (res_writable):
		if(fixed_cache_manifest == null): 
			fixed_cache_manifest = bp_cache_manifest.new()
		writalbe_cache_manifest = fixed_cache_manifest

func _get_updated_resource_list(): 
	change_callback("_on_updated_resource_list")
	Api.getEndpoint("check-cache", req, [], true, HTTPClient.METHOD_POST, _preflight_data())

func _on_updated_resource_list(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		Logger.print("Server error: " + str(json.error) +  "! Got: " + body.get_string_from_utf8(), self)
		_network_error()
		return
	if(json.result.has("should_update")):
		if(json.result.get("should_update")):
			 _check_manifest()
		else:
			_done()
	
func _check_manifest(): 
	change_callback("_on_new_manifest")
	Api.getEndpoint("update-cache", req, [], true, HTTPClient.METHOD_POST, _manifest_data())

func _on_new_manifest(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		Logger.print("Server error: " + json.error +  "! Got: " + body.get_string_from_utf8(), self)
	if (json.result.has("current_aspects")): 
		_save_aspect_data(json.result.get("current_aspects"))
	if (json.result.has("current_infobytes")): 
		_save_infobyte_data(json.result.get("current_infobytes"))
	if (json.result.has("current_tree_templates")): 
		_save_tree_template_data(json.result.get("current_tree_templates"))
	_done()

func _save_aspect_data(data):
	for aspect_data in data: 
		var path = fs + "://Network/Cache/Aspects/%s.%s" % [aspect_data["_id"], format]
		Logger.print("Saving resource for %s at %s" % [aspect_data["name"], path ], self)
		var aspect_resource = aspect_resource_type.new(aspect_data)
		writalbe_cache_manifest.insert(aspect_data["_id"], "RLocalizedAspect", fs)
		#aspect_resource.take_over_path(path)
		ResourceSaver.save(path, aspect_resource, 32)

func _save_infobyte_data(data):
	for infobyte_data in data: 
		var path = fs + "://Network/Cache/Infobytes/%s.%s" % [infobyte_data["_id"], format]
		Logger.print("Saving resource for %s at %s" % [infobyte_data["name"], path ], self)
		var infobyte_resource = infobyte_resource_type.new(infobyte_data)
		writalbe_cache_manifest.insert(infobyte_data["_id"], "RLocalizedInfobyte", fs)
		infobyte_resource.take_over_path(path)
		ResourceSaver.save(path, infobyte_resource, 32)

func _save_tree_template_data(data):
	for tree_template_data in data: 
		var path = fs + "://Network/Cache/TreeTemplates/%s.%s" % [tree_template_data["_id"], format]
		Logger.print("Saving resource for %s at %s" % [tree_template_data["ui_name"], path ], self)
		var tree_template_resource = tree_template_resource_type.new(tree_template_data)
		tree_template_resource.take_over_path(path)
		writalbe_cache_manifest.insert(tree_template_data["_id"], "RTreeTemplate", fs)
		ResourceSaver.save(path, tree_template_resource, 32)

func _done(): 
	var path = fs + "://Network/Cache/manifest.%s" % format
	Logger.print("Saving manifest", self)
	ResourceSaver.save(path, writalbe_cache_manifest, 32)
	Api.emit_signal("finished_cache")
	_load_manifest_resources()
	Api.emit_signal("cache_ready")
	
func _network_error():
	Api.set_network_status(Api.network_status_options.DOWN) 
	Api.emit_signal("finished_cache")
	_load_manifest_resources()
	Api.emit_signal("cache_ready")
	

func _load_manifest_resources(): 
	for type in type_map.keys(): 
		entities[type] = []
	fixed_cache_manifest.update(dynamic_cache_manifest.saved_entities, dynamic_cache_manifest.last_update)
	var entities_meta = fixed_cache_manifest.saved_entities
	for entity_description_key in entities_meta.keys(): 
		var entity_description = entities_meta[entity_description_key]
		var fs_path = "%s://%s/%s.%s" % [entity_description.where, type_map.get(entity_description.type), entity_description_key, format]
		var entity_resource = load(fs_path)
		if (entity_resource != null):
			entities[entity_description.type].append(entity_resource)
	is_ready = true

	
func _newer_manifest() -> bp_cache_manifest: 
	return writalbe_cache_manifest

func _preflight_data(): 
	var manifest = _newer_manifest()
	return manifest.json()
	
func _manifest_data():
	var manifest = _newer_manifest()
	fixed_cache_manifest.update(dynamic_cache_manifest.saved_entities, dynamic_cache_manifest.last_update)
	return fixed_cache_manifest.json(true)

func is_ready():
	return is_ready

func get_aspect_data_for_sector(sector):
	if !is_ready(): return null
	var aspects = entities.get("RLocalizedAspect")
	var out = []
	for aspect in aspects: 
		if aspect.bigpoint == sector:
			out.append(aspect)
	return out
	
func get_tree_templates(): 
	if !is_ready(): return null
	return entities.get("RTreeTemplate")

func get_aspect_by_name(name):
	if !is_ready(): return null
	var aspects = entities.get("RLocalizedAspect")
	for aspect in aspects:
		if aspect._id == name:
			return aspect
	return null
