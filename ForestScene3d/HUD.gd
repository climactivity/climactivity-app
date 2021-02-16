extends Control

onready var seedling_box = $SeedlingBox

func _ready():
	seedling_box.connect("dragging", self, "_disable_input")
	_show_seedling_box()

func update_hud():
	_show_seedling_box()
	
func can_drop_data(_pos, data):
	var result = get_parent().ray_cast(_pos)
	var can_drop = result != null && result.has("collider") && result.collider.has_method("place_entity")
	if (can_drop): 
		result.collider.can_drop(result.position, data["entity"])
	return can_drop

func drop_data(_pos, data):
	var result = get_parent().ray_cast(_pos)
	if (result.collider.has_method("place_entity")): 
		result.collider.place_entity(result.position, data["entity"])
	Logger.print("Input released", self)
	mouse_filter = MOUSE_FILTER_IGNORE

func _disable_input(_any):
	Logger.print("Input captured", self)
	mouse_filter = MOUSE_FILTER_STOP

func _show_seedling_box(): 
	if BoardEntityService.has_placeable_entity(): 
		seedling_box.visible = true
		seedling_box.set_entity(BoardEntityService.get_placeable_entity())
	else:
		seedling_box.visible = false
func _entity_placed():
	_show_seedling_box()
