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
		values_holder.get_node("value_entity_id").text = instance_resource.entity_id
		values_holder.get_node("value_stage").text = str(instance_resource.stage)
		values_holder.get_node("value_water_applied").text = str(instance_resource.water_applied)
		values_holder.get_node("value_water_required").text = str(instance_resource.water_required)



func _on_sub_stage_pressed():
	emit_signal("DEBUG_sub_stage")


func _on_add_stage_pressed():
	emit_signal("DEBUG_add_stage")
