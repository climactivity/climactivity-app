extends PanelContainer

export (Resource) var entity setget set_entity

onready var preview = $VBoxContainer/TextureRect
onready var title = $VBoxContainer/Label
onready var select_button = $VBoxContainer/CenterContainer/MarginContainer/select_button

var ready = false
var aspect

func _ready():
	ready = true
	if entity != null: _show_data()

func set_entity(new_entity_resource): 
	entity = new_entity_resource
	if ready: 
		_show_data()

func set_aspect(new_aspect):
	aspect = new_aspect
	
func _show_data(): 
	preview.texture = entity.preview_texture
	title.text = entity.ui_name
	# TODO show coin price if applicable
	
func _on_select_button_pressed():
	Logger.print( "Added a %s to inventory" % entity.ui_name, self)
	AspectTrackingService.consume_seedling(aspect._id)
	var new_entity = TreeTemplateFactory._make_new(entity)
	PSS.add_item_to_inventory(new_entity)
	GameManager.scene_manager.go_home()
