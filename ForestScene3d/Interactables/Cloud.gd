extends Control

signal dragging(node)

var tex_water_available = preload("res://Assets/WolkeTransparent.png")
var tex_has_water = preload("res://Assets/Wolke.png")

var has_water = false
var water_available = false
onready var sprite = $"Sprite"

func _ready():
	update_water_available()
	AspectTrackingService.connect("tracking_updated", self, "update_water_available")

func update_water_available():
	water_available = AspectTrackingService.has_water_available()
	has_water = AspectTrackingService.get_water_collected() != []
	if sprite != null: 
		if has_water: 
			sprite.texture = tex_has_water
			visible = true
		elif water_available:
			sprite.texture = tex_water_available
			visible = true
		else: 
			visible = false

var prewiew = preload("res://ForestScene3d/Interactables/Wolke_preview.tscn")

func get_drag_data(_pos):
	if !has_water: return false
	var preview = prewiew.instance()
	#preview.texture = sprite.texture
	set_drag_preview(preview)
	emit_signal("dragging", self)
	return {
		"action": "water",
		"current_water_amount": 0.0
	}


func _on_Cloud_gui_input(event):
	if event is InputEventScreenTouch:
		if event.index == 0 and event.pressed:
			if !has_water and water_available:
				Logger.print("Moving to WaterCollectionScene", self)
				GameManager.scene_manager.push_scene("water_collection_scene")
