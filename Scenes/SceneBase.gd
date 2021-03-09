tool
extends Panel
class_name SceneBase

export var accent_color = Color('#999999') setget set_accent_color

export var left_align = 64
export var right_align = 64
export var safe_area_top = 50
export var top_align = 200

export var icon = preload("res://Assets/Icons/AufforstungIcon.png")

onready var header_bg = $"ContentContainer/Content/HeaderBG"
onready var header = $"HeaderContainer/Header"
onready var content_main = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain"
export var screen_title = "Screen_Title" setget set_screen_title
var ready = false 

var gradient

func _ready(): 
	_set_vars()
	ready = true
	header.set_screen_label(screen_title)
	material = material.duplicate(true)
	gradient = material.get_shader_param("gradient")
func set_accent_color(color): 
	accent_color = color 
	if header_bg != null: _set_vars()
	
func _set_vars(): 
	header_bg.self_modulate = accent_color
	if gradient != null:
		gradient.gradient.set_color(0, accent_color)
		material.set_shader_param("gradient", gradient)
	$HeaderContainer/Header.update_header(screen_title, icon, accent_color)
	
func set_screen_title(label):
	screen_title = label
	if header != null: _set_vars()

