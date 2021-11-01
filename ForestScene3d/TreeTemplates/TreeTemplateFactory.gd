extends Node

signal tree_templates_ready

var _base_tree_scene = preload("res://ForestScene3d/TreeTemplates/BaseTree.tscn")

onready var http_request = $HTTPRequest

var texture_set_path = "res://ForestScene3d/TreeTemplates/TextureSets/"
export (Dictionary) var available_textures = {
	'apfelbaum': load("res://ForestScene3d/TreeTemplates/TextureSets/apfelbaum.tres"),
	'birke': load("res://ForestScene3d/TreeTemplates/TextureSets/birke.tres"),
	'eibe': load("res://ForestScene3d/TreeTemplates/TextureSets/eibe.tres"),
	'eiche': load("res://ForestScene3d/TreeTemplates/TextureSets/eiche.tres"),
	'esche': load("res://ForestScene3d/TreeTemplates/TextureSets/esche.tres"),
	'farn': load("res://ForestScene3d/TreeTemplates/TextureSets/farn.tres"),
	'fichte': load("res://ForestScene3d/TreeTemplates/TextureSets/fichte.tres"),
	'hasel': load("res://ForestScene3d/TreeTemplates/TextureSets/hasel.tres"),
	'heckenrose': load("res://ForestScene3d/TreeTemplates/TextureSets/heckenrose.tres"),
	'johannisbeere': load("res://ForestScene3d/TreeTemplates/TextureSets/johannisbeere.tres"),
	'kastanie': load("res://ForestScene3d/TreeTemplates/TextureSets/kastanie.tres"),
	'kiefer': load("res://ForestScene3d/TreeTemplates/TextureSets/kiefer.tres"),
	'pappel': load("res://ForestScene3d/TreeTemplates/TextureSets/pappel.tres"),
	'stechpalme': load("res://ForestScene3d/TreeTemplates/TextureSets/stechpalme.tres"),
	'tanne': load("res://ForestScene3d/TreeTemplates/TextureSets/tanne.tres"),
	'wacholder': load("res://ForestScene3d/TreeTemplates/TextureSets/wacholder.tres"),
	'weide': load("res://ForestScene3d/TreeTemplates/TextureSets/weide.tres"),
	'weissdorn': load("res://ForestScene3d/TreeTemplates/TextureSets/weissdorn.tres"),
}

# preload texture assets from application bundle
#export var available_textures = {
#	'tree0': {
#		0: preload("res://ForestScene3d/TreeTemplates/Textures/Baum_Entwurf_01.png"),
#		1: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_2.png"),
#		2: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_3.png"),
#		3: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_4.png"),
#		4: preload("res://ForestScene3d/TreeTemplates/Textures/tree0_5.png")
#	},
#	'test': {
#		0: preload("res://Assets/TestData/Sprite-0001.png"),
#		1: preload("res://Assets/TestData/Sprite-0002.png"),
#		2: preload("res://Assets/TestData/Sprite-0003.png"),
#		3: preload("res://Assets/TestData/Sprite-0004.png"),
#		4: preload("res://Assets/TestData/Sprite-0005.png"),
#	},
#	'jasmin-00': {
#		0: preload("res://Assets/sketch/setzling.png"),
#		1: preload("res://Assets/sketch/baum_jung01.png"),
#		2: preload("res://Assets/sketch/baum_jung.png"),
#		3: preload("res://Assets/sketch/baum_erwachsen.png"),
#		4: preload("res://Assets/sketch/baum_blueten.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'birke': {
#		0: preload("res://Assets/sketch/baum/Birke/birke_01.png"),
#		1: preload("res://Assets/sketch/baum/Birke/birke_02.png"),
#		2: preload("res://Assets/sketch/baum/Birke/birke_03.png"),
#		3: preload("res://Assets/sketch/baum/Birke/birke_04.png"),
#		4: preload("res://Assets/sketch/baum/Birke/birke_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'esche': {
#		0: preload("res://Assets/sketch/baum/Esche/esche_01.png"),
#		1: preload("res://Assets/sketch/baum/Esche/esche_02.png"),
#		2: preload("res://Assets/sketch/baum/Esche/esche_03.png"),
#		3: preload("res://Assets/sketch/baum/Esche/esche_04.png"),
#		4: preload("res://Assets/sketch/baum/Esche/esche_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'fichte': {
#		0: preload("res://Assets/sketch/baum/Fichte/fichte_01.png"),
#		1: preload("res://Assets/sketch/baum/Fichte/fichte_02.png"),
#		2: preload("res://Assets/sketch/baum/Fichte/fichte_03.png"),
#		3: preload("res://Assets/sketch/baum/Fichte/fichte_04.png"),
#		4: preload("res://Assets/sketch/baum/Fichte/fichte_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'kastanie': {
#		0: preload("res://Assets/sketch/baum/Kastanie/kastanie_01.png"),
#		1: preload("res://Assets/sketch/baum/Kastanie/kastanie_02.png"),
#		2: preload("res://Assets/sketch/baum/Kastanie/kastanie_03.png"),
#		3: preload("res://Assets/sketch/baum/Kastanie/kastanie_04.png"),
#		4: preload("res://Assets/sketch/baum/Kastanie/kastanie_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'pappel': {
#		0: preload("res://Assets/sketch/baum/Pappel/pappel_01.png"),
#		1: preload("res://Assets/sketch/baum/Pappel/pappel_02.png"),
#		2: preload("res://Assets/sketch/baum/Pappel/pappel_03.png"),
#		3: preload("res://Assets/sketch/baum/Pappel/pappel_04.png"),
#		4: preload("res://Assets/sketch/baum/Pappel/pappel_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'tanne': {
#		0: preload("res://Assets/sketch/baum/Tanne/tanne_01.png"),
#		1: preload("res://Assets/sketch/baum/Tanne/tanne_02.png"),
#		2: preload("res://Assets/sketch/baum/Tanne/tanne_03.png"),
#		3: preload("res://Assets/sketch/baum/Tanne/tanne_04.png"),
#		4: preload("res://Assets/sketch/baum/Tanne/tanne_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'weide': {
#		0: preload("res://Assets/sketch/baum/Weide/weide_01.png"),
#		1: preload("res://Assets/sketch/baum/Weide/weide_02.png"),
#		2: preload("res://Assets/sketch/baum/Weide/weide_03.png"),
#		3: preload("res://Assets/sketch/baum/Weide/weide_04.png"),
#		4: preload("res://Assets/sketch/baum/Weide/weide_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'busch': {
#		0: preload("res://Assets/sketch/busch/busch_setzling.png"),
#		1: preload("res://Assets/sketch/busch/busch_jung01.png"),
#		2: preload("res://Assets/sketch/busch/busch_jung02.png"),
#		3: preload("res://Assets/sketch/busch/busch.png"),
#		4: preload("res://Assets/sketch/busch/busch_berries.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'heckenrose': {
#		0: preload("res://Assets/sketch/busch/busch_setzling.png"),
#		1: preload("res://Assets/sketch/busch/Heckenrose/heckenrose_02.png"),
#		2: preload("res://Assets/sketch/busch/Heckenrose/heckenrose_03.png"),
#		3: preload("res://Assets/sketch/busch/Heckenrose/heckenrose_04.png"),
#		4: preload("res://Assets/sketch/busch/Heckenrose/heckenrose_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#	'wacholder': {
#		0: preload("res://Assets/sketch/busch/busch_setzling.png"),
#		1: preload("res://Assets/sketch/busch/Wacholder/wacholder_02.png"),
#		2: preload("res://Assets/sketch/busch/Wacholder/wacholder_03.png"),
#		3: preload("res://Assets/sketch/busch/Wacholder/wacholder_04.png"),
#		4: preload("res://Assets/sketch/busch/Wacholder/wacholder_05.png"),
#		'sizes': {
#			0: 0.4,
#			1: 0.6,
#			2: 0.8,
#			3: 1.0,
#			4: 1.0
#		}
#	},
#}

var _example_template = {
	"_id": "undefined",
	"template_name": "tree0",
	"texture_name": "test",
	"ui_name": "Test Baum",
	"preview_name": "stage2",
	"coin_value": 0,
	"bigpoint_available": ["ernaehrung"],
	"unlock_level": 5,
	"preview_texture": {
		"resource_path": "res://Assets/sketch/baum/Apfelbaum/apfelbaum_02.png"
	},
	"initial_state": {
		"stage": 0,
		"water": 0.0,
		"water_needed": 40.0,
		"bigpoint": "ernährung",
		"aspect": "pflanzliche_ernährung"
	}
}

var _tree_templates = [{
	"tree0": _example_template
}]

#func _preload_textures():
#	var dir = Directory.new()
#
#	if dir.open(texture_set_path) == OK:
#		dir.list_dir_begin()
#		var file_name = dir.get_next()
#		while file_name != "":
#			if !dir.current_is_dir():
#
#				available_textures[file_name.trim_suffix('.tres')] = load(texture_set_path + '/' + file_name)
#			file_name = dir.get_next()
#	else:
#		Logger.error("Could not open texture_set_path.")
#	Logger.print("Loaded %d texture sets" % available_textures.size(), self)


func _ready(): 
#	_preload_textures()
	Api.connect("cache_ready", self, "load_templates")
	if Api.get_tree_templates() != null:
		load_templates()
		
func load_templates(): 
	_tree_templates = Api.get_tree_templates()
	for template in _tree_templates: 
		template.texture_data = available_textures[template.texture_name]
		template.preview_texture = available_textures[template.texture_name].get(int(template.preview_name)) # ain't that some jank
		if template.has_method("save_texture_assignment"): template.save_texture_assignment()
	emit_signal("tree_templates_ready")

func available_templates():
	return _tree_templates.keys()
	
func templates_in_sector(sector_name): 
	var out = []
	for template in _tree_templates:
		#if template.bigpoint_available.find(sector_name) != -1:
		#if template.archetype == "tree":
		out.push_back(template)
	return out

func get_available_templates(sector_name: String, type: String = "tree") -> Array: 
	var out = []
	for template in _tree_templates: 
		if template.type == type:
			out.push_back(template)
#		if template.bigpoint_available.find(sector_name) != -1 and template.archetype == type:
#			out.push_back(template)
	return out

func get_all_templates() -> Array: 
	return _tree_templates

func is_ready(): 
	return _tree_templates is Array

func get_template(key):
	if !(_tree_templates is Array): 
		yield(self, "tree_templates_ready")
	for template in _tree_templates: 
		if template._id == key:
			return template

	Logger.error("Entity template for " + str(key) + " not found!", self)
	return null 

func _make_new(resource):
	var new_tree = _base_tree_scene.instance()
	new_tree.set_state(resource)
	resource.node = new_tree
	#new_tree.set_textures(available_textures[template["texture_name"]])
	return new_tree

# used to generate scenes from entity resources
func rehydrate(entity): 
	var new_tree = _make_new(entity)
	return new_tree
