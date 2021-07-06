extends Resource
class_name RTreeTemplateTextures

export (Texture) var tex_0
export (Texture) var tex_1
export (Texture) var tex_2
export (Texture) var tex_3
export (Texture) var tex_4

export (Dictionary) var sizes = {
	0: 0.4,
	1: 0.6,
	2: 0.8,
	3: 1.0,
	4: 1.0
}

func has(variant): 
	if variant is String: 
		if variant == "sizes":
			return sizes != null
	if variant is int: 
		match variant: 
			0:
				return tex_0 != null 
			1:
				return tex_1 != null 
			2:
				return tex_2 != null 
			3:
				return tex_3 != null 
			4:
				return tex_4 != null 
	return false
	
func get(variant): 
	if variant is String: 
		if variant == "sizes":
			return sizes 
	if variant is int: 
		match variant: 
			0:
				return tex_0 
			1:
				return tex_1 
			2:
				return tex_2 
			3:
				return tex_3 
			4:
				return tex_4
	return null
