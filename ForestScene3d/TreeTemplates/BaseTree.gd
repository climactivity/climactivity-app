extends Spatial

# important globally unique id
var entity_id

var template_resource # RTreeTemplate
var instance_resource # RBoardEntity

var scale_factor = 1.0

# components
onready var bill_board = $"Sprite3D"
onready var anim_player = $"AnimationPlayer"
onready var tile = $MeshInstance
onready var ui_alert = $"Sprite3D/SpatialUIPanel"

func _ready():
	if(!OS.is_debug_build()): tile.visible = false
	ui_alert.visible = false
	update_view()

func update_view():
	if( template_resource == null || instance_resource == null || bill_board == null): return
	var texture_key = int(instance_resource.stage)
	if template_resource.texture_data.has(texture_key): 
		var current_texture = template_resource.texture_data.get(texture_key)
		bill_board.set_texture(current_texture)
		if template_resource.texture_data.has("sizes"):
			var sizes = template_resource.texture_data.get("sizes") 
			if sizes.has(texture_key):
				bill_board.apply_scaling_factor(sizes[texture_key])
			else:
				Logger.error("Missing factor in sizes!", self)
		else:
			Logger.print("Non scaling factors found!", self)
	else: 
		Logger.error("Missing key %s in %s from %s" % [texture_key, template_resource._id, instance_resource._id], self)

func get_state(): 
	return instance_resource


func set_state(state):
	instance_resource = state
	template_resource = instance_resource.tree_template
	entity_id = instance_resource.entity_id
	update_view()


	
func set_textures(new_textures):
	template_resource.texture_data = new_textures
	update_view()

func add_water(amount): 
	pass

func alert_can_water(): 
	Logger.print("show can be watered alert", self)
	ui_alert.visible = true
