extends Sprite3D

func set_texture(new_texture): 
	texture = new_texture
	offset = Vector2( -texture.get_size().x / 2.0,0.0)
