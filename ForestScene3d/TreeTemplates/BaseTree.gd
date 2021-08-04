extends Spatial
export (PackedScene) var _details_widget 
var details_widget setget , get_details_widget
export var offset_scale = .2
# important globally unique id
var entity_id

var template_resource # RTreeTemplate
var instance_resource # RBoardEntity

var scale_factor = 1.71
var can_water = false
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
	$AnimationTarget.translate_object_local(Vector3(instance_resource.center_offset.x, 0.0, instance_resource.center_offset.y) * offset_scale )
	
	if instance_resource.just_planted:
		_planted()
	if _details_widget != null: details_widget = _details_widget.instance()
	details_widget.set_entity(self)
	details_widget.connect("DEBUG_add_stage", self, "DEBUG_add_stage")
	details_widget.connect("DEBUG_sub_stage", self, "DEBUG_sub_stage")

func get_details_widget(): 
#	details_widget.show_entity()
	return details_widget

func update_view(animate = false):
	if( template_resource == null || instance_resource == null || bill_board == null): return
	var texture_key = int(instance_resource.stage)
	var old_texture = bill_board.texture
	var old_size = bill_board._unit_factor
	var current_texture
	var current_size
	if template_resource.texture_data.has(texture_key): 
		current_texture = template_resource.texture_data.get(texture_key)
		#bill_board.set_texture(current_texture)
		if template_resource.texture_data.has("sizes"):
			var sizes = template_resource.texture_data.get("sizes") 
			if sizes.has(texture_key):
				current_size = sizes[texture_key] * (1.2 if template_resource.type == 'tree' else 0.8)
				#bill_board.set_unit_factor(sizes[texture_key])
				if animate:
					_animate_update(current_texture, current_size, old_texture, old_size)
				else:
					bill_board.set_texture(current_texture)
					bill_board.set_unit_factor(current_size)
			else:
				Logger.error("Missing factor in sizes!", self)
		else:
			Logger.print("Non scaling factors found!", self)
	else: 
		Logger.error("Missing key %s in %s from %s" % [texture_key, template_resource._id, instance_resource._id], self)

func _animate_update(new_texture, new_size, old_texture, old_size): 
	bill_board.set_texture(new_texture)
	bill_board.set_unit_factor(new_size)
	$AnimationTarget.set_texture(old_texture)
	$AnimationTarget.set_unit_factor(old_size)
	var anim = $AnimationPlayer.get_animation("stage_inc")
	var track = anim.find_track("AnimationTarget:_unit_factor")
	anim.track_set_key_value(track, 0, old_size)
	anim.track_set_key_value(track, 1, new_size)
	$AnimationPlayer.play("stage_inc")
	
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
	details_widget.set_entity(self)
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
		_after_water()
		return
	timeout -= 0.5
	$AnimationPlayer.play("happy")
	$AnimationPlayer.connect("animation_finished", self, "_add_water", [timeout])

func _after_water():
	_flush()
	can_water = false
	if instance_resource.water_applied > instance_resource.water_required: 
		instance_resource.water_applied -= instance_resource.water_applied
		if instance_resource.stage >= 4:
			return
		instance_resource.stage += 1 
		_update_stage()

func _update_stage(): 
	Logger.print("Current stage %s" % str(instance_resource.stage), self)
	update_view(true)
	if instance_resource.stage == 4: 
		var aspect = instance_resource.aspect_id
		var tracking_level = AspectTrackingService.get_current_tracking_level(aspect)
#		var reward = null
#		for option in aspect.tracking.options: 
#			if option.level == tracking_level.level:
#				reward = option.reward
		if tracking_level.reward != null: 
			RewardService.add_reward(tracking_level.reward)
	_flush()
	
func DEBUG_add_stage(): 
	if instance_resource.stage >= 4:
			return
	instance_resource.stage += 1 
	_update_stage()
	
func DEBUG_sub_stage(): 
	if instance_resource.stage <= 0:
		return
	instance_resource.stage -= 1 
	_update_stage()

	
func _planted(): 
	$AnimationPlayer.play("planted")
	instance_resource.just_planted = false
	_flush()
func alert_has_water_avaialble():
	pass

func alert_can_water(): 
	Logger.print("show can be watered alert", self)
	ui_alert.visible = true
	bill_board.layout_ui()
	$Collider/CollisionShape.disabled = false
	can_water = true

func _on_Collider_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed: 
		on_touch()

func _flush(): 
	if PSS != null:
		PSS.flush()

func can_water():
	return can_water
