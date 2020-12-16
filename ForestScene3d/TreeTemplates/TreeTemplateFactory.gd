extends Node

var _base_tree_scene = preload("res://ForestScene3d/TreeTemplates/BaseTree.tscn")

# preload texture assets from application bundle
var available_textures = {
	'tree0': {
		0: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_1.png"),
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

func _ready():
	# TODO
	# load tree templates from fs 
	# check if stored tree templates are current 
	# update
	# set _tree_templates with current values
	# persist updates
	pass

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
