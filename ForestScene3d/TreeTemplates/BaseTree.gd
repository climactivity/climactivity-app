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
onready var collider = $Collider
func _ready():
	if(!OS.is_debug_build()): tile.visible = false
	ui_alert.visible = false
	update_view()
	ui_alert.connect("clicked", self, "on_click")
	collider.connect("getting_watered", self, "add_water")

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

func add_water(water): 
	$AnimationPlayer.play("happy")
	#AspectTrackingService.water_used(AspectTrackingService.water_collected_for[0])
	instance_resource.consume_water(water.current_water_amount)

func alert_has_water_avaialble():
	pass

func alert_can_water(): 
	Logger.print("show can be watered alert", self)
	ui_alert.visible = true
	bill_board.layout_ui()

func on_click():
	print("click")

func _on_Collider_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed: 
		on_click()
