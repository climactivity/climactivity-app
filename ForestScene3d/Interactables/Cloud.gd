extends Control

signal dragging(node)

var current_water_amount = 20.0
onready var sprite = $"Sprite"

var prewiew = preload("res://ForestScene3d/Interactables/Wolke_preview.tscn")

func get_drag_data(_pos):
	if (current_water_amount <= 0.0): return false
	var preview = prewiew.instance()
	#preview.texture = sprite.texture
	set_drag_preview(preview)
	emit_signal("dragging", self)
	return {
		"action": "water",
		"current_water_amount": current_water_amount
	}
