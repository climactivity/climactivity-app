extends Control
signal free_place
export var free_placement = false 
onready var cb_free_placement = $"VBox/HBoxContainer/CheckBox"
func _ready():
	if !OS.is_debug_build(): 
		queue_free()

func _set_free_placement_mode(b):
	free_placement = b
	emit_signal("free_place", free_placement)

func _input(event):
	if (!OS.is_debug_build()): return
	if (event is InputEventKey and event.scancode == KEY_F and event.is_pressed()):
		free_placement = !free_placement
		cb_free_placement.pressed = free_placement
	
