extends Control

export (Texture) var texture setget set_texture
onready var tex = $TextureRect

func _ready():
	tex.set_deferred("texture", texture)

func set_texture(variant): 
	texture = variant

