extends Node

var _base_tree_scene = preload("res://ForestScene3d/TreeTemplates/BaseTree.tscn")
var initial_state = preload("res://ForestScene3d/TreeTemplates/InitialState.tres")

onready var http_request = $HTTPRequest

# preload texture assets from application bundle
var available_textures = {
	'tree0': {
		0: preload("res://ForestScene3d/TreeTemplates/Textures/Baum_Entwurf_01.png"),
		1: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_2.png"),
		2: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_3.png"),
		3: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_4.png"),
		4: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_5.png")
	},
	'test': {
		0: preload("res://Assets/TestData/Sprite-0001.png"),
		1: preload("res://Assets/TestData/Sprite-0002.png"),
		2: preload("res://Assets/TestData/Sprite-0003.png"),
		3: preload("res://Assets/TestData/Sprite-0004.png"),
		4: preload("res://Assets/TestData/Sprite-0005.png"),
	}
}

var _example_template = {
	"_id": "undefined",
	"template_name": "tree0",
	"texture_name": "test",
	"ui_name": "Test Baum",
	"preview_name": "stage2",
	"coin_value": 0,
	"bigpoint_available": ["ernaehrung"],
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

func _ready(): 
	Api.connect("cache_ready", self, "load_templates")
	if Api.get_tree_templates() != null:
		load_templates()
		
func load_templates(): 
	_tree_templates = Api.get_tree_templates()
	for template in _tree_templates: 
		template.texture_data = available_textures[template.texture_name]
		template.preview_texture = available_textures[template.texture_name][int(template.preview_name)] # ain't that some jank
		if template.has_method("save_texture_assignment"): template.save_texture_assignment()

func available_templates():
	return _tree_templates.keys()
	
func templates_in_sector(sector_name): 
	var out = []
	for template in _tree_templates:
		if template.bigpoint_available.find(sector_name) != -1:
			out.push_back(template)
	return out
	
func get_template(key):
	if _tree_templates.has(key):
		return _tree_templates.get(key)
	else:
		Logger.error("Entity template for " + str(key) + " not found!", self)
		return null 

func _make_new(resource):
	var new_tree = _base_tree_scene.instance()
	new_tree.set_state(resource)
	#new_tree.set_textures(available_textures[template["texture_name"]])
	return new_tree

# used to generate scenes from entity resources
func rehydrate(entity): 
	var new_tree = _make_new(entity)
	return new_tree
