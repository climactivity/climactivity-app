extends Control

onready var seedling_box = $SeedlingBox
onready var cloud_widget  = $Cloud


func _ready():
	seedling_box.connect("dragging", self, "_disable_input")
	cloud_widget.connect("dragging", self, "_disable_input")
	_show_seedling_box()

func update_hud():
	_show_seedling_box()
	_show_cloud()
	
func can_drop_data(_pos, data):
	if data.has("entity"):
		return _can_drop_seedling(_pos, data)
	else:
		return _can_drop_cloud(_pos, data)

func _can_drop_seedling(_pos, data):
	var result = get_parent().ray_cast(_pos)
	var can_drop = result != null && result.has("collider") && result.collider.has_method("place_entity")
	if (can_drop): 
		result.collider.can_drop(result.position, data["entity"])
	return result.collider if result != null && result.has("collider") else null
	
func _can_drop_cloud(_pos, data):
	var result = get_parent().ray_cast(_pos)
	var can_drop = result != null && result.has("collider") && result.collider.has_method("water")
#	if result.has("collider"): print(_pos, result.collider.name, can_drop)
	if (can_drop): 
		result.collider.can_drop(result.position, data["water"])
		return result.collider
	return false

func drop_data(_pos, data): 
	if data.has("entity"):
		_drop_data_seedling(_pos, data)
	else:
		_drop_data_cloud(_pos, data)

func _drop_data_seedling(_pos, data):
	var result = get_parent().ray_cast(_pos)
	if (result.collider.has_method("place_entity")): 
		result.collider.place_entity(result.position, data["entity"])
	Logger.print("Input released", self)
	mouse_filter = MOUSE_FILTER_IGNORE

func _drop_data_cloud(_pos, data):
	var result = get_parent().ray_cast(_pos)
	if (result.collider.has_method("water")): 
		result.collider.water(result.position, data["water"])
	_enable_input()

func _disable_input(_any):
	Logger.print("Input captured", self)
	mouse_filter = MOUSE_FILTER_STOP

func _enable_input(): 
	Logger.print("Input released", self)
	mouse_filter = MOUSE_FILTER_IGNORE

func _show_seedling_box(): 
	if BoardEntityService.has_placeable_entity(): 
		seedling_box.visible = true
		seedling_box.set_entity(BoardEntityService.get_placeable_entity())
	else:
		seedling_box.visible = false

func _show_cloud(): 
	if AspectTrackingService.has_water_available(): 
		cloud_widget.visible = true
	else: 
		cloud_widget.visible = false
		
func _entity_placed():
	_show_seedling_box()
