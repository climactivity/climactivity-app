extends Node

var _base_tree_scene = preload("res://ForestScene3d/TreeTemplates/BaseTree.tscn")
onready var http_request = $HTTPRequest

# preload texture assets from application bundle
var available_textures = {
	'tree0': {
		0: preload("res://ForestScene3d/TreeTemplates/Textures/Baum_Entwurf_01.png"),
		1: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_2.png"),
		2: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_3.png"),
		3: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_4.png"),
		4: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_5.png")
	}
}

var _example_template = {
	"_id": "undefined",
	"template_name": "tree0",
	"texture_name": "tree0",
	"ui_name": "Test Baum",
	"preview_name": "stage2",
	"coin_value": 0,
	"bigpoint_available": ["ernährung"],
	"initial_state": {
		"stage": 0,
		"water": 0.0,
		"water_needed": 40.0,
		"bigpoint": "ernährung",
		"aspect": "pflanzliche_ernährung"
	}
}

var _tree_templates = {
	"tree0": _example_template
}

var templates_cache_path = "user://tree-templates.json"
var persist_templates = true

func _ready():
	# load tree templates from fs 
	var templates_cache_file = File.new()
	if(!templates_cache_file.file_exists(templates_cache_path)):
		if(templates_cache_file.open(templates_cache_path, File.READ) != 0):
			var saved_data = JSON.parse(templates_cache_file.get_as_text()).result	
			if(saved_data != null && saved_data.has("templates")): 
				_tree_templates = saved_data["templates"]
			templates_cache_file.close()
		else:
			Logger.error("Error opening " + templates_cache_path, self)
	http_request.connect("request_completed", self, "_on_request_completed")
	Api.getEndpoint("tree_templates_list", http_request)

func available_templates():
	return _tree_templates.keys()

func make_new(template_name: String):
	if (_tree_templates.has(template_name)):
		return _make_new(_tree_templates.get(template_name))
	else:
		Logger.error("TreeTemplate " + str(template_name) + " not found!", self)

func _make_new(template):
	var new_tree = _base_tree_scene.instance()
	new_tree.set_template(template, true)
	new_tree.set_textures(available_textures[template["texture_name"]])
	return new_tree


func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if (response_code >= 399): 
		print("Error ", response_code)
		return
	if(json.error): 
		print("Server error: ", json.error)
	else:
		# set _tree_templates with current values
		#print(json.result)
		for template in json.result:
			if _tree_templates.has(template.template_name): 
				Logger.print("Updating " + template.template_name, self)
				_tree_templates[template.template_name] = template
			else:
				Logger.print("Adding " + template.template_name, self)
				_tree_templates[template.template_name] = template
		# persist updates
		var templates_cache_file = File.new()
		if(templates_cache_file.open(templates_cache_path, File.WRITE) == 0):
			var save_data = JSON.print({
				"templates": _tree_templates
			}, "\t")
			Logger.print("Persisting in " + templates_cache_file.get_path_absolute(), self)
			templates_cache_file.store_string(save_data)
			templates_cache_file.close()
		else: 
			Logger.error("Error opening " + templates_cache_path, self)
