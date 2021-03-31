tool
extends Sprite

export (Texture) var tex setget set_texture

func _ready():
	_set_texture()
	
func set_texture(new_tex):
	tex = new_tex
	_set_texture()

func _set_texture():
	texture = tex
	
