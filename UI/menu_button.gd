tool 
extends PanelContainer
class_name CyMenuButton

signal pressed
export (Color) var primary_color = Color("#636362") setget set_primary_color
export (Texture) var icon = preload("res://Assets/Icons/wtree-solid.svg") setget set_icon
export (String) var menu_label = "menu" setget set_label_text 
export var alert_visible = false setget set_alert_visible
onready var tex : TextureRect = $MarginContainer/VBoxContainer/tex
onready var label : Label = $MarginContainer/VBoxContainer/Label

func _ready(): 
	tex.self_modulate = primary_color
	tex.texture = icon
	label.text = menu_label

func set_primary_color(color : Color):
	primary_color = color
	if tex != null:
		tex.self_modulate = primary_color

func set_label_text(label_text): 
	menu_label = tr(label_text)
	if label != null: 
		label.text = menu_label

func set_icon(_icon):
	icon = _icon
	if tex != null: 
		tex.texture = icon

func _on_HomeButton_pressed():
	emit_signal("pressed")

func set_alert_visible(_visible):
	alert_visible = _visible
	$"MarginContainer/VBoxContainer/tex/Control/Alert".visible = alert_visible
