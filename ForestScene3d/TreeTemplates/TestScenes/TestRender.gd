
extends Spatial

export (Texture) var texture = preload("res://Assets/sketch/baum_erwachsen.png") setget setT
export (bool) var castS = true setget setCastS
export (float) var sf = 1.0 setget setS
func init_at(params):
	pass

func _ready(): 
	#$ContactShadow.visible = castS
	#$Sprite3D.set_unit_factor(sf)
	#$Sprite3D.set_texture(texture)3
	if $Sprite3D.texture != null: $Sprite3D.set_texture(texture)
	if $Sprite3D.texture == null: $ContactShadow.visible = false
	pass
	
func setCastS(b):
	castS = b
	if $ContactShadow != null: $ContactShadow.visible = castS
	
func setT(tex):
	texture = tex
	if $Sprite3D != null: $Sprite3D.set_texture(texture)

func setS(s):
	sf= s
	#if $Sprite3D != null: $Sprite3D.set_unit_factor(s)

func growth_anim():
	$AnimationPlayer.play("grow")

func plop():
	visible = true
	$AnimationPlayer.play("plop")
