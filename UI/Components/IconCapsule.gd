extends Panel

const default_texture = preload("res://Assets/TestData/checkered.png")

export var bg_color = Color('#a7a7a7') setget set_bg
export var border_color = Color('#ffffff') setget set_border
export var icon_texture = default_texture setget set_icon

onready var panel = $BG_Icon
onready var icon = $BG_Icon/Icon

func _ready (): 
	_redraw()

func set_bg(bg): 
	bg_color = bg
	property_list_changed_notify ( )
	_redraw()

func set_border(color):
	border_color = color
	property_list_changed_notify ( )
	_redraw()

func set_icon(tex):
	icon_texture = tex
	property_list_changed_notify ( )
	_redraw()


func _redraw(): 
	if (panel != null && icon != null):
		icon.texture = icon_texture if icon_texture != null else default_texture
		panel.get_stylebox("panel").set("border_color", bg_color)
		get_stylebox("panel").set("bg_color", border_color)
