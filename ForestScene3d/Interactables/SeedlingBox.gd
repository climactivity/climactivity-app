extends Control

signal dragging(node)
signal trying_to_place()
signal placed(where, what)
signal cancle()
var entity setget set_entity
var hud
var current_tile 
var drag_data
var initial_pos = Vector2.ZERO
onready var seedling = $Seedling

func _ready(): 
	hud = get_parent()
	initial_pos = seedling.position
	
func set_entity(new_entity): 
	entity = new_entity
	drag_data = {
		"icon": entity.tree_template.preview_texture,
		"action": "place",
		"entity": entity
	}
#	if seedling != null: 
#		$Seedling/Offset/_Seedling.texture = drag_data.entity.tree_template.texture_data[0]
		
#func get_drag_data(_pos):
#	var preview = TextureRect.new()
#	preview.texture = entity.tree_template.preview_texture
#	set_drag_preview(preview)
#	emit_signal("dragging", self)
#	return {
#		"icon": entity.tree_template.preview_texture,
#		"action": "place",
#		"entity": entity
#	}

var dragging = false

func reset():
	var start_offset = seedling.position
	var duration = .5
	$Tween.interpolate_property($Seedling/Offset, "position", Vector2(0.0, -500.0), Vector2.ZERO, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(seedling, "position", start_offset, initial_pos, duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_callback(self, duration, "_reset_done")
	$Tween.start()

func _reset_done(): 
	seedling.show_pot(true)
	if hud != null and hud.has_method("_enable_input"):
			hud._enable_input()

func place_entity(): 
	emit_signal("dragging", false)
	trying_to_place = false
	emit_signal("placed", last_pos, entity)
	seedling.position = initial_pos
	$Seedling/Offset.position = Vector2.ZERO
	seedling.show_pot(true)
	if hud != null and hud.has_method("_enable_input"):
		hud._enable_input()

func dropped_entity():
	emit_signal("dragging", false)
	trying_to_place = false
	emit_signal("cancle")
	reset()
	
var trying_to_place = false
var last_pos
func _input(event):
	if !dragging or trying_to_place: return
	if event is InputEventScreenTouch and event.index == 0:
		dragging = false
		if hud.can_drop_data(event.position, drag_data):
			last_pos = event.position
			trying_to_place = true
			emit_signal("trying_to_place")
			return
		reset()
		if hud != null and hud.has_method("_enable_input"):
			hud._enable_input()
		return
	if event is InputEventScreenDrag:
		seedling.position += event.relative # * (1.0/cloud.transform.get_scale().x)
		current_tile = hud.can_drop_data(event.position + Vector2(0.0, -110.0), drag_data)
		if current_tile != null: 
			print("hover ", current_tile)



func _on_SeedlingBox_gui_input(event):
	if event is InputEventScreenTouch and event.index == 0:
		if  event.pressed:
			dragging = true
			seedling.show_pot(false)
			$Tween.interpolate_property($Seedling/Offset, "position", Vector2.ZERO, Vector2(0.0, -500.0), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			emit_signal("dragging", true)
			if hud != null and hud.has_method("_disable_input"):
				hud._disable_input({})
			return


func _on_PlantButton_pressed():
	place_entity()


func _on_Abbrechen_pressed():
	dropped_entity()
