extends Spatial
export (PackedScene) var _details_widget 
var details_widget setget , get_details_widget
export var offset_scale = .2
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
	bill_board.translate_object_local(Vector3(instance_resource.center_offset.x, 0.0, instance_resource.center_offset.y) * offset_scale )
	if _details_widget != null: details_widget = _details_widget.instance()
	
func get_details_widget(): 
	return details_widget

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

func focus_entity() -> Spatial:
	return $CameraZoomTarget as Spatial

func on_touch():
	print("focus")
	if is_instance_valid(GameManager) and GameManager.camera != null: 
		GameManager.camera.focus_entity(self)

func set_textures(new_textures):
	template_resource.texture_data = new_textures
	update_view()

var getting_watered = false

func add_water(water): 
	if getting_watered: return
	print(water)
	#$AnimationPlayer.play("happy")
	AspectTrackingService.water_used(instance_resource.aspect_id)
	getting_watered = true
	_add_water(null,instance_resource.current_water/10.0)
	
func _add_water( anim ,timeout): 
	$AnimationPlayer.disconnect("animation_finished", self, "_add_water")
	if (timeout <= 0.0):
		getting_watered = false
		ui_alert.visible = false
		return
	timeout -= 0.5
	$AnimationPlayer.play("happy")
	$AnimationPlayer.connect("animation_finished", self, "_add_water", [timeout])

func alert_has_water_avaialble():
	pass

func alert_can_water(): 
	Logger.print("show can be watered alert", self)
	ui_alert.visible = true
	bill_board.layout_ui()
	$Collider/CollisionShape.disabled = false


func _on_Collider_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed: 
		on_touch()
