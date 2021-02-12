tool
extends Sprite3D

export (float) var _unit_factor = 1.0 setget _set_unit_factor

func _ready():
	_offset_and_scale()
	
func set_texture(new_texture): 
	texture = new_texture
	_offset_and_scale()

func _set_unit_factor(new_factor):
	_unit_factor = new_factor
	_offset_and_scale()
	
func _offset_and_scale():
	pixel_size = _unit_factor / texture.get_size().y  
	offset = Vector2( -texture.get_size().x / 2.0,0.0)
	print("_offset_and_scale %s %s" % [str(pixel_size), str(offset)])
