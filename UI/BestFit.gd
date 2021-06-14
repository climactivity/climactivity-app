extends Label

# Shrink a font until all text is shown by the label.
# directly works on the labels DynamicFont resource, so make that unique 
# thanks to https://github.com/godotengine/godot/issues/21706#issuecomment-725036796

var font : DynamicFont
var origial_size
export (int) var max_size = 0
export var min_size = 8

func _enter_tree():
	font = get("custom_fonts/font")
	origial_size = font.size

func fit_on_box():
	font.size = max_size if max_size != 0 else origial_size;
	if autowrap: 
		while get_visible_line_count() < get_line_count(): 
			if !_shrink():
				break
	else:
		var font_box = font.get_string_size(text)
		while font_box.y > rect_size.y || font_box.x > rect_size.x:
			font_box = font.get_string_size(text)
			if !_shrink():
				break
				
func _shrink(): 
	font.size -= 1
	if font.size <= min_size:
		font.size = min_size
		return false
	return true

func set_text(new_text): 
	text = new_text
	fit_on_box()
