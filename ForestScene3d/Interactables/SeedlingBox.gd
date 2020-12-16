extends Control

signal dragging(node)

onready var sprite = $"Sprite"

func get_drag_data(_pos):
	var preview = TextureRect.new()
	preview.texture = sprite.texture
	set_drag_preview(preview)
	emit_signal("dragging", self)
	return {
		"icon": sprite.texture,
		"action": "plant",
		"template_name": "tree0"
	}
