extends Control

signal dragging(node)

onready var sprite = $"Sprite"

var entity setget set_entity

func _ready(): 
	_update_preview()
	
func set_entity(new_entity): 
	entity = new_entity
	_update_preview()
	
func _update_preview(): 
	if (sprite != null && entity != null && entity.get("tree_template") != null):
		sprite.texture = entity.tree_template.preview_texture
		
func get_drag_data(_pos):
	var preview = TextureRect.new()
	preview.texture = sprite.texture
	set_drag_preview(preview)
	emit_signal("dragging", self)
	return {
		"icon": sprite.texture,
		"action": "place",
		"entity": entity
	}
