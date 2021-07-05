extends TextureRect

export var greyness = 0.0 setget set_greyness

func set_greyness(val): 
	greyness = val
	material.set_shader_param("greyness", greyness)
