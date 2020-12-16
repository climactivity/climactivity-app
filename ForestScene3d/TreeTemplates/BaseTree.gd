extends Spatial

# template data
var _id
var template_name
var texture_name
var ui_name
var preview_name
var coin_value
var bigpoint_available

# instance data
var stage
var water
var water_needed
var bigpoint
var aspect

# ephemeral instance data
var textures

# components
onready var bill_board = $"Sprite3D"
onready var anim_player = $"AnimationPlayer"

func _ready():
	if( stage == null || textures == null ): return
	bill_board.texture = textures[stage]



func get_state(): 
	return {
		"stage": stage,
		"water": water,
		"water_needed": water_needed,
		"bigpoint": bigpoint,
		"aspect": aspect 
	}

func save(): 
	return {
		"node_name": name,
		"scene_name": filename,
		"instance_data": get_state(),
		"template_name": template_name
	}

func set_template(template, use_initial_state):
	_id = template["_id"]	
	template_name = template["template_name"]
	texture_name = template["texture_name"]
	ui_name = template["ui_name"]
	preview_name = template["preview_name"]
	coin_value = template["coin_value"]
	bigpoint_available = template["bigpoint_available"]
	if(use_initial_state):
		set_state(template["initial_state"])

func set_state(state):
	stage = state["stage"]
	water = state["water"]
	water_needed = state["water_needed"]
	bigpoint = state["bigpoint"]
	aspect = state["aspect"]

func set_textures(new_textures):
	textures = new_textures
	if (is_instance_valid(bill_board)): bill_board.texture = textures[stage]

func add_water(amount): 
	pass


