extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var valid_location = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
	   print("Mouse Click/Unclick at: ", event.position, " Hi from Area2D")


func _on_PlaceArea_area_entered(area):
	if(area.has_method("can_place")): 
		if(area.can_place(self)):
			valid_location = true
