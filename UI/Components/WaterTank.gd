tool
extends PanelContainer
class_name WaterTank 

signal clicked
export var can_be_clicked = true
export var bg_color = Color('#a7a7a7') setget set_bg
export var border_color = Color('#ffffff') setget set_border
export (float, 0.0, 1.0, 0.01) var percent = 0.0 setget set_percent
export var no_current_entity = false setget set_no_current_entity
onready var panel = $BG_Icon
onready var icon = $BG_Icon/Icon

func _ready (): 
	panel.material = preload("res://UI/Components/MWaterTank.tres").duplicate()
	_redraw()

func set_no_current_entity(_no_current_entity):
	no_current_entity = _no_current_entity
	_redraw()
	
func set_bg(bg): 
	bg_color = bg
	property_list_changed_notify ( )
	_redraw()

func set_border(color):
	border_color = color
	property_list_changed_notify ( )
	_redraw()

func set_percent(new_percent):
	percent = new_percent
	property_list_changed_notify ( )
	_redraw()



func _redraw(): 
	if (panel != null && icon != null):
		panel.self_modulate = bg_color
		self_modulate = border_color
		if Engine.is_editor_hint():
			return
		if no_current_entity:
			panel.material.set_shader_param("percent_complete", 0.0)
			icon.texture = preload("res://Assets/sketch/baum/setzling.png")
		else:
			panel.material.set_shader_param("percent_complete", percent)
		if !can_be_clicked: 
			icon.texture = preload("res://Assets/droplet_gray.png")

var down = false
var last_pos = Vector2.ZERO

func _on_Icon_gui_input(event):
	if event is InputEventScreenTouch:
		if !can_be_clicked: return
		print(event.as_text(), " ", down)
		if  event.pressed:
			down = true
			last_pos = event.position

		else:
			if down:
				emit_signal("clicked")
				$droplets.emitting = !no_current_entity
			else: 
				down = false
