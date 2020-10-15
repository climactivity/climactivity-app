extends Node2D

var water = 0.0 setget set_water, get_water 
onready var water_meter = $MoistMeter/Control/RadialProgressBar 
var tween = Tween.new();

func _ready():
	water_meter.set_progress(0.0)
	

func _on_PickArea_area_entered(area):
	if area.get_parent().is_in_group("cloud"):
		print("Tree ", name, " is getting watered!")
		set_water(65.0)

func _on_PickArea_input_event(viewport, event, shape_idx):
	pass # Replace with function body.

func set_water(new_water):	
	water_meter.animate(2000, false, new_water)
	water = new_water 
func get_water():
	return water
