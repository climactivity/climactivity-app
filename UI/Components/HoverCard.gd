tool
extends Control

var width = 64
var height = 64

export var NORMAL_SCALE = 1.0
export var HOVER_SCALE = 1.5 

var target_scale = 1.0
var actual_scale = 1.0

export var interaction_pos = Vector2.ZERO

var mouse_on_card = false

func _ready():
	width = rect_size.x
	height = rect_size.y
	material = material.duplicate()
	material.set_shader_param("width", width)
	material.set_shader_param("height", height)

func _process(delta): 
	actual_scale = lerp(actual_scale, target_scale, 5 * delta)
#	if not mouse_on_card: 
#		interaction_pos = interaction_pos.linear_interpolate(Vector2.ZERO, 5*delta)
#
	material.set_shader_param("scale", actual_scale)
	material.set_shader_param("interaction_pos", interaction_pos)

#	interaction_pos = Vector2(interaction_pos.x + delta,0)
#func _gui_input(event):
#	if event is InputEventMouseMotion:
#		print("viewport input event: " + str(event.position))
#		var actual_rect = null
#		if mouse_on_card:
#			actual_rect = get_rect().grow(width * HOVER_SCALE - width)
#		else: 
#			actual_rect = get_rect() 
#
#		if actual_rect.has_point(event.position):
#			mouse_on_card = true
#			material.set_shader_param("skew_enabled", true)
#			target_scale = HOVER_SCALE
#			interaction_pos = event.position
#		else:
#			if mouse_on_card:	
#				mouse_on_card = false
#				material.set_shader_param("skew_enabled", false)
#				target_scale = NORMAL_SCALE

func _on_Option_selected(option):
	material.set_shader_param("skew_enabled", true)
	target_scale = HOVER_SCALE
	mouse_on_card = true
