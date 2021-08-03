extends PanelContainer

export (Resource) var entity setget set_entity

onready var preview = $VBoxContainer/TextureRect
onready var title = $VBoxContainer/Label
onready var select_button = $VBoxContainer/MarginContainer/select_button
onready var select_button_label = $VBoxContainer/MarginContainer/select_button/RichTextLabel

var ready = false
var is_confirm_box = false
var was_clicked = false
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
	var select_button_text = '[center]' + (tr("select_entity") if entity.coin_value == 0 else tr("buy_entity") % entity.coin_value)
	select_button_label.bbcode_text = select_button_text
	if BoardEntityService.can_buy(entity): 
		select_button.disabled = false
		
	else: 
		select_button.disabled = true
	# TODO show coin price if applicable

func _on_select_button_pressed():
	if is_confirm_box:

		if was_clicked:
			return

		Logger.print( "Added a %s to inventory" % entity.ui_name, self)
		var err = BoardEntityService.add_entity(entity, aspect)
		if err == OK: 
			GameManager.scene_manager.go_home()
		else: 
			Logger.error(err)
		_close_overlay_nav()
	else:
		_open_overlay()

var initial_position
func _open_overlay():
	initial_position = self.get_global_transform().origin
	var confirm_box = load("res://UI/Components/SelectEntityCard.tscn").instance()
	confirm_box.set_entity(entity)
	confirm_box.set_aspect(aspect)
	confirm_box.is_confirm_box = true
	confirm_box.initial_position = initial_position
	GameManager.overlay._show_popup(confirm_box)
	GameManager.overlay.connect("popup_hide", confirm_box, '_close_overlay')
	var center = (get_viewport_rect().size / 2) - ( rect_size / 2)
	$Tween.interpolate_property(confirm_box, "rect_global_position", initial_position , center, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.interpolate_property(confirm_box, "modulate", Color.transparent , Color.white, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.start()

func _close_overlay_nav(): 
	was_clicked = true
	GameManager.overlay.disconnect("popup_hide", self, '_close_overlay')
	$Tween.interpolate_property(self, "rect_global_position", get_global_transform().origin , Vector2(350.0,70.0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.interpolate_callback(GameManager.overlay, .5, '_close_popup')
	$Tween.interpolate_callback(self, 1.0, 'queue_free')
	$Tween.start()
	
func _close_overlay():
	was_clicked = true
	$Tween.interpolate_property(self, "rect_global_position", get_global_transform().origin , initial_position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
#	$Tween.interpolate_callback(GameManager.overlay, 1.0, '_close_popup')
	$Tween.interpolate_callback(self, 1.0, 'queue_free')
	$Tween.start()
#	GameManager.overlay.call_deferred("_close_popup")
