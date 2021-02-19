extends Panel
class_name SceneBase

export var accent_color = Color('#999999') setget set_accent_color

export var left_align = 64
export var right_align = 64
export var safe_area_top = 50
export var top_align = 200

onready var header_bg = $"ContentContainer/Content/HeaderBG"

func _ready(): 
	_set_accent_color()
func set_accent_color(color): 
	accent_color = color 

func _set_accent_color(): 
	header_bg.self_modulate = accent_color
