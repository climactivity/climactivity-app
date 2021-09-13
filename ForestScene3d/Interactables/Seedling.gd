tool
extends Node2D

export (Texture) var tex setget set_texture
export var pot_visible = true setget show_pot

func _ready():
	_set_texture()
	
func set_texture(new_tex):
	tex = new_tex
	_set_texture()

func _set_texture():
	if $Offset/_Seedling == null: return
	$Offset/_Seedling.texture = tex
	
func show_pot(b):
	pot_visible = b
	$Offset/Pot.visible = pot_visible
