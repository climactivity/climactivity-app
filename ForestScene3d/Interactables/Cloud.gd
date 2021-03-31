extends Control

signal dragging(node)

var tex_water_available = preload("res://Assets/sketch/wolke_outline.png")
var tex_has_water = preload("res://Assets/sketch/wolke_outline_gestrichelt.png")


onready var sprite = $"preview"
onready var cloud = $CloudSprite
var hud
var drag_data

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
	match cloud_state:
		Cloud_States.EMPTY:
			_reset_done()
		Cloud_States.CAN_COLLECT:
			sprite.texture = tex_water_available
			visible = true
		Cloud_States.READY:
			sprite.texture = tex_has_water
			visible = true
		Cloud_States.RESETING:
			pass
		Cloud_States.DRAGGING:
			pass
		Cloud_States.WATERING:
			_watering()
			
func update_water_available():
	Logger.print("update water available", self)

	water_available = AspectTrackingService.has_water_available()
	has_water = AspectTrackingService.get_water_collected() != []
	if sprite == null: return
	if AspectTrackingService.get_water_collected() != []: 
		set_state(Cloud_States.READY)
	
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
		"water": {
			"current_water_amount": 0.0,
		}
	}



func _on_Cloud_gui_input(event):
	if event is InputEventScreenTouch:
		if event.index == 0 and event.pressed:
			if !has_water and water_available:
				Logger.print("Moving to WaterCollectionScene", self)
				GameManager.scene_manager.push_scene("water_collection_scene")
			else: 
				start_drag() 

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

#var resetting = false
#var t = 0.0
#
#func _process(delta):
#	if resetting: 
#		t += delta
#		if t > 1.0: 
#			t = 0.0
#			_reset_done()
#		else:
			

func _reset(): 
#	resetting = true
#	t = 0.0
	var start_offset = $CloudSprite.offset
	var duration = .5
	$Tween.interpolate_property($CloudSprite, "offset", start_offset, Vector2(0.0,0.0), duration,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_callback(self, duration, "_reset_done")
	$Tween.start()

	
func _reset_done(): 
	sprite.visible = true
	cloud.visible = false

func _watering(): 
	$Particles2D.emitting = true

func _input(event):
	if !dragging: return
	if event is InputEventScreenTouch and  event.index == 0 and not event.pressed:
		dragging = false
		_reset()
		if hud != null and hud.has_method("_enable_input"):
			hud._enable_input()
		return
	if event is InputEventScreenDrag:
		cloud.offset += event.relative * (1.0/cloud.transform.get_scale().x)
		if (hud.can_drop_data(event.position, drag_data)): 
			print("pong")
