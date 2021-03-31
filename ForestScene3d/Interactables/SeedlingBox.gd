extends Control

signal dragging(node)



var entity setget set_entity
var hud
var current_tile 
var drag_data
var inital_pos = Vector2.ZERO
onready var seedling = $Seedling

func _ready(): 
	hud = get_parent()
	inital_pos = seedling.position
	
func set_entity(new_entity): 
	entity = new_entity
	drag_data = {
		"icon": entity.tree_template.preview_texture,
		"action": "place",
		"entity": entity
	}
	
		
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
	$Tween.interpolate_property(seedling, "position", start_offset, inital_pos, duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_callback(self, duration, "_reset_done")
	$Tween.start()
	
func _input(event):
	if !dragging: return
	if event is InputEventScreenTouch and event.index == 0:
		if  event.pressed:
			dragging = true
			if hud != null and hud.has_method("_disable_input"):
				hud._disable_input({})
			return
		else:	
			dragging = false
			reset()
			if hud != null and hud.has_method("_enable_input"):
				hud._enable_input()
			return
	if event is InputEventScreenDrag:
		seedling.position += event.relative # * (1.0/cloud.transform.get_scale().x)
		current_tile = hud.can_drop_data(event.position, drag_data)
		if current_tile != null: 
			print("hover ", current_tile)



func _on_SeedlingBox_gui_input(event):
	if event is InputEventScreenTouch and event.index == 0:
		if  event.pressed:
			dragging = true
			if hud != null and hud.has_method("_disable_input"):
				hud._disable_input({})
			return
