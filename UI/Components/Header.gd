tool
extends Panel

export var screen_label = "Screen Label" setget set_screen_label
export var icon_texture = preload("res://Assets/Icons/AufforstungIcon.png") setget set_icon_texture
export var color = Color("95c11f") setget set_color 

onready var back_button = $BG/BackButton
onready var label = $BG/Label
onready var icon_bg = $BG/BG_Category/BG_Icon
onready var icon = $BG/BG_Category/BG_Icon/Icon

func _ready():
	label.text = screen_label
	icon.texture = icon_texture

func _on_BackButton_pressed():
	GameManager.scene_manager.pop_scene()

func set_screen_label(new_label): 
	screen_label = new_label
	if(is_instance_valid(label)):
		label.text = screen_label

func set_icon_texture(new_texture): 
	icon_texture = new_texture
	if(is_instance_valid(label)):
		icon.texture = icon_texture

func set_color(new_color): 
	color = new_color
	if(is_instance_valid(icon_bg)):
		icon_bg.set("custom_styles/panel/bg_color", color)