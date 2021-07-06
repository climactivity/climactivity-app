extends Resource
class_name RTreeTemplate


#var _example_template = {
#	"_id": "undefined",
#	"template_name": "tree0",
#	"texture_name": "tree0",
#	"ui_name": "Test Baum",
#	"preview_name": "stage2",
#	"coin_value": 0,
#	"bigpoint_available": ["ernährung"],
#	"initial_state": {
#		"stage": 0,
#		"water": 0.0,
#		"water_needed": 40.0,
#		"bigpoint": "ernährung",
#		"aspect": "pflanzliche_ernährung"
#	}
#}


export (String) var _id 
export (String) var template_name 
export (String) var texture_name
export (String) var type
export (String) var ui_name
export (String) var preview_name 
export (int) var coin_value 
export (Array) var bigpoint_available 
export (Dictionary) var texture_data
export (Texture) var preview_texture

func _init(p_dict = {}): 
	_id =  p_dict["_id"] if p_dict.has("_id") else ""
	type = p_dict["archetype"] if p_dict.has("archetype") else 'tree'
	template_name =  p_dict["template_name"] if p_dict.has("template_name") else ""
	texture_name =  p_dict["texture_name"] if p_dict.has("texture_name") else ""
	ui_name =  p_dict["ui_name"] if p_dict.has("ui_name") else ""
	preview_name =  p_dict["preview_name"] if p_dict.has("preview_name") else ""
	coin_value =  p_dict["coin_value"] if p_dict.has("coin_value") else ""
	bigpoint_available =  p_dict["bigpoint_available"] if p_dict.has("bigpoint_available") else []
	texture_data =  p_dict["texture_data"] if p_dict.has("texture_data") else {}

func save_texture_assignment(): 
	ResourceSaver.save(get_path(), self)

func _save(): 
	pass
