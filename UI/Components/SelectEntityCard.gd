extends PanelContainer

export (Resource) var entity setget set_entity

onready var preview = $VBoxContainer/TextureRect
onready var title = $VBoxContainer/Label
onready var select_button = $VBoxContainer/CenterContainer/MarginContainer/select_button

var ready = false

func _ready():
	ready = true
	_show_data()

func set_entity(new_entity_resource): 
	entity = new_entity_resource
	if ready: 
		_show_data()
		
func _show_data(): 
	preview.texture = entity.preview_texture
	title.text = entity.name
	# TODO show coin price if applicable
	
func _on_select_button_pressed():
	pass # Replace with function body.
