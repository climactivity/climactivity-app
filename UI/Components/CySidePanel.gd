tool
extends Container

onready var content_holder = $Chrome/VBoxContainer/MarginContainer/Content
onready var chrome_holder = $Chrome
onready var heading = $"Chrome/VBoxContainer/Header/HeadingContainer/VBoxContainer/MarginContainer/Heading"
export var top_left = Vector2(0.0,0.0) setget set_topleft_offset

export (String) var heading_text setget set_heading

func _ready():
	heading.text = heading_text

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		for child in get_children(): 
			#content_holder.add_child(child)
			if (chrome_holder != null  and child != chrome_holder):
				fit_child_in_rect( child, Rect2( top_left, content_holder.rect_size - top_left) )
			else: 
				fit_child_in_rect( child, Rect2( Vector2(), rect_size ) )
			
func set_topleft_offset(vec2: Vector2):
	top_left = vec2
	queue_sort()

func set_heading(text):
	heading_text = text
	if heading != null: heading.text = heading_text
