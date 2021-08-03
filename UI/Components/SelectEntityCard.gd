extends PanelContainer

export (Resource) var entity setget set_entity

onready var preview = $VBoxContainer/TextureRect
onready var title = $VBoxContainer/Label
onready var select_button = $VBoxContainer/CenterContainer/MarginContainer/select_button
onready var select_button_label = $VBoxContainer/CenterContainer/MarginContainer/select_button/RichTextLabel

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
	var select_button_text = '[center]' + tr("select_entity") if entity.coin_value == 0 else tr("buy_entity") % entity.coin_value
	select_button_label.bbcode_text = select_button_text
	if BoardEntityService.can_buy(entity): 
		select_button.disabled = false
		
	else: 
		select_button.disabled = true
	# TODO show coin price if applicable
	
func _on_select_button_pressed():
	Logger.print( "Added a %s to inventory" % entity.ui_name, self)
	var err = BoardEntityService.add_entity(entity, aspect)
	if err == OK: 
		GameManager.scene_manager.go_home()
	else: 
		Logger.error(err)
