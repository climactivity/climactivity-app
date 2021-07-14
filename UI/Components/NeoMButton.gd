tool
extends Panel

signal pressed 

export var icon_left = false setget set_icon_align_left
export var icon_texture = preload("res://Assets/Icons/Arrow - Right 2.png") setget set_icon_textrue
export var texture_min_size = 48 setget set_icon_size
export var font_color = Color(0,0,0,1) setget set_font_color 
export var font_color_disabled = Color(.3,.3,.3,1) setget set_font_color_disabled
export var text = "" setget set_text
export var button_disabled = false setget set_disabled
export var color_icon = false setget set_color_icon
export var h_sep = 0 setget set_h_sep
onready var button = $Panel2/Button
onready var content_holder = $Panel2/Button/MarginContainer/HBoxContainer
onready var label = $Panel2/Button/MarginContainer/HBoxContainer/Label
onready var icon = $Panel2/Button/MarginContainer/HBoxContainer/TextureRect

func _ready(): 
	set_text(text)
	set_icon_align_left(icon_left)
	set_icon_textrue(icon_texture)
	set_font_color(font_color)
	_update_colors()
	set_disabled(button_disabled)
	set_color_icon(color_icon)

func set_h_sep(sep): 
	h_sep  = sep 
	if(is_instance_valid(content_holder)):
		content_holder.set("custom_constants/separation", h_sep)
func set_icon_textrue(texture: Texture): 
	icon_texture = texture
	if(icon == null): return
	icon.texture = icon_texture
	set_icon_size(texture_min_size)

func set_icon_align_left(left):
	icon_left = left
	if(is_instance_valid(content_holder)):
		if(icon_left):
			content_holder.move_child(label,1)
			content_holder.alignment = content_holder.ALIGN_BEGIN
		else:
			content_holder.move_child(label,0)
			content_holder.alignment = content_holder.ALIGN_END
func set_icon_size(new_size):
	texture_min_size = new_size
	if(icon == null): return
	if (icon_texture != null):
		icon.rect_min_size = Vector2(new_size, new_size)
	else:
		icon.rect_min_size = Vector2.ZERO

func _update_colors():
	if(!is_instance_valid(label) || !is_instance_valid(button)): return
	if(button_disabled):
		label.set("custom_colors/font_color", font_color_disabled)
	else:
		label.set("custom_colors/font_color", font_color)
#		button.set("custom_styles/pressed/custom_styles/border_color", font_color)
	if(icon != null):
		if(color_icon):
			icon.modulate = font_color_disabled if button_disabled else font_color
		else:
			icon.modulate = Color(1.0,1.0,1.0,1.0)


func set_font_color(new_color):
	font_color = new_color
	_update_colors()

func set_font_color_disabled(new_color):
	font_color_disabled = new_color
	_update_colors()

func set_text(new_text):
	text = str(new_text)
	if(label == null): return
	label.text = text
	
func set_disabled(new_disabled):
	button_disabled = new_disabled
	if(is_instance_valid(button)):
		button.disabled = new_disabled
		_update_colors()

func set_color_icon(new_color_icon):
	color_icon = new_color_icon
	_update_colors()


func _on_Button_pressed():
	emit_signal("pressed")
