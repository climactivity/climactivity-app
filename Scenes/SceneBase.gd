extends Panel
class_name SceneBase

export var accent_color = Color('#999999') setget set_accent_color

export var left_align = 64
export var right_align = 64
export var safe_area_top = 50
export var top_align = 200

onready var header_bg = $"ContentContainer/Content/HeaderBG"
onready var header = $"HeaderContainer/Header"

export var screen_title = "Screen_Title" setget set_screen_title
var ready = false 

func _ready(): 
	_set_accent_color()
	ready = true
	header.set_screen_label(screen_title)
func set_accent_color(color): 
	accent_color = color 
	if header_bg != null: _set_accent_color()
func _set_accent_color(): 
	header_bg.self_modulate = accent_color

func set_screen_title(label):
	screen_title = label
	header.set_screen_label(screen_title)
