tool
extends Panel
class_name ProgressCapsule 

signal clicked

const completed_texture = preload("res://Assets/Theme/Checkmark.png")

export (float, 0.0, 100.0, 1.0) var progress = 0.0 setget set_progress
export var border_color = Color('#696968') setget set_border
export var border_color_completed = Color('#77B924') setget set_border_completed
export (Texture) var icon_texture = null setget set_icon
export var show_icon = false setget set_show_icon
var ready = false

onready var icon = $CenterIcon/Icon
onready var progress_bar = $TextureProgress
onready var progress_label = $CenterIcon/Label

func _ready (): 
	ready = true
	_redraw()

func set_show_icon(_show_icon): 
	show_icon = _show_icon
	_redraw()

func set_border(color):
	border_color = color
	_redraw()

func set_progress(_progress):
	progress = _progress
	_redraw()

func set_border_completed(color):
	border_color_completed = color
	_redraw()


func set_icon(tex):
	icon_texture = tex
	_redraw()

func _redraw(): 
	if icon == null or progress_bar == null: return
	icon.texture = completed_texture if progress >= 100.0 else icon_texture
	icon.visible = progress >= 100.0 or show_icon
	progress_label.text = "%3d %%" % progress
	progress_label.visible = !(progress >= 100.0 or show_icon)
	progress_bar.tint_progress =  border_color_completed if progress >= 100.0 else border_color
	progress_bar.value = progress
	
func _on_Icon_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked")
