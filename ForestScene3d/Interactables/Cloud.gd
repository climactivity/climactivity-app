extends Control

signal dragging(node)

var tex_water_available = preload("res://Assets/sketch/wolke_mask.png")
var tex_has_water = preload("res://Assets/sketch/wolke_outline.png")
var tex_empty = preload("res://Assets/sketch/wolke_outline_gestrichelt.png")

onready var sprite = $"preview"
onready var cloud = $CloudSprite
onready var drops = $CloudSprite/Particles2D
var hud
var drag_data
var currently_watering
var has_water = false
var water_available = false
var dragging = false
enum Cloud_States {
	READY,
	EMPTY,
	CAN_COLLECT,
	RESETING,
	DRAGGING,
	WATERING
}

var cloud_state = Cloud_States.EMPTY setget set_state

func _ready():
	update_water_available()
	AspectTrackingService.connect("tracking_updated", self, "update_water_available")
	hud = get_parent()
	

func set_state(state): 
	cloud_state = state
	print(cloud_state)
	if drops != null: drops.emitting = false
	match cloud_state:
		Cloud_States.EMPTY:
			sprite.texture = tex_empty
		Cloud_States.CAN_COLLECT:
			sprite.texture = tex_has_water
			visible = true
		Cloud_States.READY:
			sprite.texture = tex_water_available
			visible = true
		Cloud_States.RESETING:
			pass
		Cloud_States.DRAGGING:
			pass
		Cloud_States.WATERING:
			pass
			
func update_water_available():
	Logger.print("update water available", self)
	water_available = AspectTrackingService.has_water_available()
	has_water = AspectTrackingService.get_water_collected() != []
	if sprite == null: return
	if cloud_state == Cloud_States.DRAGGING or cloud_state == Cloud_States.WATERING or cloud_state == Cloud_States.RESETING:
		return 
	if AspectTrackingService.get_water_collected() != []: 
		set_state(Cloud_States.READY)
		return
	elif AspectTrackingService.has_water_available():
		set_state(Cloud_States.CAN_COLLECT)
		return
	else: 
		set_state(Cloud_States.EMPTY)

var prewiew = preload("res://ForestScene3d/Interactables/Wolke_preview.tscn")

func get_drag_data(_pos):
	if !has_water: return false
	var preview = prewiew.instance()
	#preview.texture = sprite.texture
	set_drag_preview(preview)
	emit_signal("dragging", self)
	return {
		"action": "water",
		"water": {
			"current_water_amount": 0.0,
		}
	}

func _on_Cloud_gui_input(event):
	if event is InputEventScreenTouch:
		if event.index == 0 and event.pressed:
			if cloud_state == Cloud_States.CAN_COLLECT:
				Logger.print("Moving to WaterCollectionScene", self)
				GameManager.scene_manager.push_scene("water_collection_scene")
			else: 
				if cloud_state == Cloud_States.READY: return
				

func start_drag(): 
	dragging = true
	sprite.visible = false
	cloud.visible = true
	emit_signal("dragging", self)
	drag_data = {
		"action": "water",
		"water": {
			"current_water_amount": 0.0,
		}
	}
	cloud.set_fill_state(1.0)
	set_state(Cloud_States.DRAGGING)
	
func _reset(): 
#	resetting = true
#	t = 0.0
	var start_offset = $CloudSprite.position
	var duration = .5
	$Tween.interpolate_property($CloudSprite, "position", start_offset, Vector2(0.0,0.0), duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_callback(self, duration, "_reset_done")
	$Tween.start()

	
func _reset_done(): 
	set_state(Cloud_States.READY)
	sprite.visible = true
	cloud.visible = false
	update_water_available()

func _watering(other): 
	var start_position = $CloudSprite.position
	var target_position =  GameManager.camera.unproject_position(other.get_global_transform().origin)
#	print( start_position, ", other: ", other.get_global_transform().origin, ", unprojected: ",target_position)
	var duration = .5
	$Tween.interpolate_property($CloudSprite, "position", start_position, Vector2(-target_position.x, target_position.y - 300)/2.0, duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_callback(self, duration, "_watering_progress")
	$Tween.start()

func _watering_progress():
	drops.emitting = true
	var duration = 2
	$Tween.interpolate_callback(self, duration, "_watering_done")
	$Tween.start()

func _watering_done(): 
	set_state(Cloud_States.DRAGGING)
	drops.emitting = false
	currently_watering = null
	
func _input(event):
	if cloud_state != Cloud_States.DRAGGING: return
	if event is InputEventScreenTouch and  event.index == 0 and not event.pressed:
		dragging = false
		_reset()
		if hud != null and hud.has_method("_enable_input"):
			hud._enable_input()
		return
	if event is InputEventScreenDrag:
		cloud.position += event.relative # * (1.0/cloud.transform.get_scale().x)
		currently_watering = hud.can_drop_data(event.position, drag_data)
		if currently_watering != null and typeof(currently_watering) == TYPE_OBJECT: 
			_watering(currently_watering)
