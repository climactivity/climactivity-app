extends Control

onready var seedling_box = $SeedlingBox

func _ready():
	seedling_box.connect("dragging", self, "_disable_input")

func can_drop_data(_pos, data):
	var result = get_parent().ray_cast(_pos)
	var can_drop = result != null && result.has("collider") && result.collider.has_method("place_object")
	if (can_drop): 
		result.collider.can_drop(result.position, data["template_name"])
	return can_drop

func drop_data(_pos, data):
	var result = get_parent().ray_cast(_pos)
	if (result.collider.has_method("place_object")): 
		result.collider.place_object(result.position, data["template_name"])
	Logger.print("Input released", self)
	mouse_filter = MOUSE_FILTER_IGNORE

func _disable_input(_any):
	Logger.print("Input captured", self)
	mouse_filter = MOUSE_FILTER_STOP
