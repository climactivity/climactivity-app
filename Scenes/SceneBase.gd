tool
extends Panel
class_name SceneBase

export var accent_color = Color('#999999') setget set_accent_color

export var left_align = 64
export var right_align = 64
export var safe_area_top = 50
export var top_align = 200

export (String) var intro_gate_var
export (String) var intro_timeline
export (float) var intro_autoplay_delay

export var icon = preload("res://Assets/Icons/AufforstungIcon.png")

export (NodePath) var navigation_dispatcher 
var _navigation_data

signal align_top(offset)
signal header_shadow_alpha(shadow_alpha)

onready var header_bg = $"ContentContainer/Content/HeaderBG"
onready var header = $"HeaderContainer/Header"
onready var content_main = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain"
export var screen_title = "Screen_Title" setget set_screen_title
onready var scroll_container = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer
var ready = false 
 
var gradient

func _ready(): 
	_set_vars()
	ready = true
	align_top()
	header.set_screen_label(screen_title)
	material = material.duplicate(true)
	gradient = material.get_shader_param("gradient")
	dispatch_nav_data()
	play_intro(intro_timeline, intro_gate_var, intro_autoplay_delay)
	scroll_container.connect("scrolled", self, "on_scroll")

func on_scroll(scroll_pos):
#	print("scroll: " + str(scroll_pos))
	var shadow_alpha = clamp(Util.map_to_range(float(scroll_pos), 60.0,130.0,0.0,1.0), 0.0, 1.0)
	header_bg.modulate.a = shadow_alpha
	emit_signal("header_shadow_alpha", shadow_alpha)

func _restored(): 
	play_intro(intro_timeline, intro_gate_var, intro_autoplay_delay)

var bottom_margin

func play_intro(timeline, gate_var, delay, force = false):
	if GameManager == null: return
	GameManager.overlay.hide_available_tutorial()
	if not gate_var or not timeline:
		return
	if force or Dialogic.get_variable(gate_var) == "0" or Util.debug_dialog():
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		Logger.print("Playing intro", self)
		GameManager.overlay.show_dialog(timeline)
	else: 
		GameManager.overlay.show_available_tutorial(timeline)
		if bottom_margin == null:
			bottom_margin = HSeparator.new()
			bottom_margin.set("custom_constants/separation", 150)
			bottom_margin.set("custom_styles/separator", load("res://UI/theme/style_box_empty.tres"))
			content_main.add_child( bottom_margin)
			content_main.move_child(bottom_margin, content_main.get_child_count())
func align_top(): 
	var safe_area = OS.get_window_safe_area()
	var header_sep = $"HeaderContainer/HSeparator"
	var header_bg_sep = $"ContentContainer/Content/HeaderBG/HSeparator2"
	var body_sep = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/HSeparator"
	var header_offset = 100 + OS.get_window_safe_area().position.y /2
	var body_offset = 246 + header_offset
	header_sep.set("custom_constants/separation", header_offset)
	header_bg_sep.set("custom_constants/separation", body_offset)
	body_sep.set("custom_constants/separation", body_offset)
	Logger.print("Aligning to %d:%d" % [header_offset,body_offset], self)
	emit_signal("align_top", body_offset)
func set_accent_color(color): 
	accent_color = color 
	if header_bg != null: _set_vars()

func set_header_icon(drawable: Texture): 
	icon = drawable
	if header != null: _set_vars()

func _set_vars(): 
	Logger.print("Update", self)
	header_bg.self_modulate = accent_color
	if gradient != null:
		gradient.gradient.set_color(0, accent_color)
		material.set_shader_param("gradient", gradient)
	$HeaderContainer/Header.update_header(screen_title, icon, accent_color)
func set_screen_title(label):
	screen_title = label
	if header != null: _set_vars()

func receive_navigation(navigation_data): 
	_navigation_data = navigation_data
	dispatch_nav_data()
func dispatch_nav_data():
	if _navigation_data == null: return
	if navigation_dispatcher == null: return
	var dispatcher =  self.get_node(navigation_dispatcher)
	if dispatcher == null:
		 return 
	else:
		if dispatcher.has_method("receive_navigation"):
			dispatcher.receive_navigation(_navigation_data)


func _on_Button_pressed():
	pass # Replace with function body.



