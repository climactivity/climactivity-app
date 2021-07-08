extends TextureRect

export var frame = 0 setget set_frame 

func set_frame(_frame): 
	frame = _frame
	AtlasTexture 
