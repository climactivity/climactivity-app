extends PanelContainer

signal DEBUG_add_stage()
signal DEBUG_sub_stage()

var focused_entity setget set_entity
var ready = false
func _on_Button_pressed():
	if GameManager != null and GameManager.camera != null:
		GameManager.camera.unfocus_entity()

func _ready():
	ready = true
	show_entity()
	
func set_entity(entity):
	focused_entity = entity
	show_entity()
	
func show_entity(): 
	if !ready: return
	if focused_entity != null and focused_entity.get("instance_resource"):
		var instance_resource = focused_entity.instance_resource
		var values_holder = $VBoxContainer/HBoxContainer/Values
#		values_holder.get_node("value_entity_id").text = instance_resource.entity_id
#		values_holder.get_node("value_water_applied").text = str(instance_resource.water_applied)
#		values_holder.get_node("value_water_required").text = str(instance_resource.water_required)
		values_holder.get_node("value_kind").text = str(instance_resource.tree_template.ui_name)
		values_holder.get_node("value_age").text = _remaining_growth_period_label(instance_resource)
		values_holder.get_node("value_stage").text = _height_label(instance_resource)
		values_holder.get_node("value_aspect").text = _aspect_label(instance_resource)
		$VBoxContainer/value_tracking_option_text.text = _tracked_option_label(instance_resource) 
		
func _remaining_growth_period_label(instance_resource) -> String: 
	var time_remaining = (OS.get_unix_time() - instance_resource.planted_at) / Util.DAY
	if time_remaining > instance_resource.growth_period/Util.DAY:
		return tr("tree_growth_done")
	return "%d / %d Tage" % [time_remaining ,instance_resource.growth_period/Util.DAY]
	
func _height_label(instance_resource) -> String: 
	return "%1d (%2d" % [instance_resource.stage + 1, 100*instance_resource.water_applied/instance_resource.water_required if instance_resource.water_required != 0 else 1] + "%) von 5"

func _aspect_label(instance_resource) -> String: 
	return instance_resource.aspect_id.title

func _tracked_option_label(instance_resource) -> String: 
	var tracking_state = AspectTrackingService.get_tracking_state(instance_resource.aspect_id)
	var current_level = tracking_state.current
	if instance_resource.aspect_id.tracking.has("options"):
		var options = instance_resource.aspect_id.tracking.get("options")
		
#		var __int = options.get(0)
#		var __float = options.get(0.0)
#		var __str = options.get("0")
		
		var selected_option = options[current_level.level as int]
		return selected_option.option

	return "Test"

func _on_sub_stage_pressed():
	emit_signal("DEBUG_sub_stage")


func _on_add_stage_pressed():
	emit_signal("DEBUG_add_stage")


func _on_show_tracking_button_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/AspectScene.tscn", {"aspect": focused_entity.instance_resource.aspect_id})
