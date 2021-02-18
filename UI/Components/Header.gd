tool
extends Panel

signal go_back

export var screen_label = "Screen Label" setget set_screen_label
export var icon_texture = preload("res://Assets/Icons/AufforstungIcon.png") setget set_icon_texture
export var color = Color("95c11f") setget set_color 
export (bool) var back_button_override = false

onready var back_button = $BG/BackButton
onready var label = $BG/Label
onready var icon = $BG/BG_Category

func _ready():
	label.set_text(screen_label)
	icon.set_icon(icon_texture)
	icon.set_bg(color)
	#icon.set_border(color)
func _on_BackButton_pressed():
	emit_signal("go_back")
	if (!back_button_override): 
		GameManager.scene_manager.pop_scene()

func update_header(new_label = null, new_texture = null, new_color = null):
	if(new_label != null): set_screen_label(new_label)
	if(new_texture != null): set_icon_texture(new_texture)
	if(new_color != null): set_color(new_color)

func set_screen_label(new_label): 
	screen_label = new_label
	if(is_instance_valid(label)):
		label.set_text(screen_label)

func set_icon_texture(new_texture): 
	icon_texture = new_texture
	if(is_instance_valid(label)):
		icon.set_icon(icon_texture)

func set_color(new_color): 
	color = new_color
	if(is_instance_valid(icon)):
		icon.set_bg(color)
