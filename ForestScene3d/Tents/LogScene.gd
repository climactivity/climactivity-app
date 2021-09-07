tool 
extends Spatial

enum LogFacing {
	rl,
	lr, 
	up,
	right
}

var textures = {
	LogFacing.rl: preload("res://Assets/sketch/baumstamm/baumstamm.png"),
	LogFacing.lr: preload("res://Assets/sketch/baumstamm/baumstamm_mirror.png"),
	LogFacing.up: preload("res://Assets/sketch/baumstamm/baumstamm_up.png"),
	LogFacing.right: preload("res://Assets/sketch/baumstamm/baumstamm02.png"),
}

export (LogFacing) var facing = LogFacing.rl setget set_facing
export (bool) var show_person = false setget set_show_person
export (bool) var show_log = true setget set_show_log
export (bool) var log_infront = false setget set_log_infront
export (Texture) var person_tex = preload("res://Assets/sketch/character01.png") setget set_person_tex
export (Texture) var person_texB = preload("res://Assets/sketch/character01.png") setget set_person_texB
export (Texture) var person_texf setget set_person_texf
export var offset = Vector3.ZERO setget set_offset
export var f_offset = Vector3.ZERO setget set_f_offset
export var use_b = false setget set_useB
export var show_f = false setget set_showF
var ready = false
func _ready():
	ready = true
	_set_sprite()

func init_at(params = [Vector2(0,0)]): 
	if is_instance_valid(Logger): 
		Logger.print("Placed log at %s" % params, self)
	if params[0].x > 0 || params[0] == Vector2(-1,-1): 
		$Sprite3D.flip_h = true 

func set_show_person(is_show_person): 
	show_person = is_show_person
	_set_sprite()

func set_show_log(is_show_log): 
	show_log = is_show_log
	_set_sprite()

func set_log_infront(_log_infront): 
	log_infront = _log_infront
	_set_sprite()

func set_person_tex(new_tex):
	person_tex = new_tex
	_set_sprite()
func set_person_texB(new_tex):
	person_texB = new_tex
	_set_sprite()

func set_person_texf(new_tex):
	person_texf = new_tex
	_set_sprite()	

func set_facing(log_facing): 
	facing = log_facing
	_set_sprite()

func set_f_offset(_offset):
	f_offset = _offset
	_set_sprite()

func set_offset(_offset):
	offset = _offset
	_set_sprite()
func set_useB(_b): 
	use_b = _b
	_set_sprite()
func set_showF(_f):
	show_f = _f
	_set_sprite()
func _set_sprite():
	if !ready: return
	if !textures.has(facing):
		print("No texture for %s" + str(facing), self)
		return
	if $Sprite3D != null:
		$Sprite3D.set_texture(textures.get(facing))
		$Sprite3D.visible = show_log
		$Sprite3D.translation.z = 0.1 if log_infront else 0.0
		if offset != Vector3.ZERO: 
			$Sprite3D.transform.origin = offset
	if !use_b:
		if person_tex != null and $SittingPlace/Person != null: 
			$SittingPlace/Person.set_texture(person_tex)
			$SittingPlace/Person.visible = show_person
	else:
		if person_texB != null and $SittingPlace/Person != null: 
			$SittingPlace/Person.set_texture(person_texB)
			$SittingPlace/Person.visible = show_person
	$SittingPlace/F.visible = person_texf != null and show_f
	$SittingPlace/F.texture = person_texf
	$SittingPlace/F.transform.origin = f_offset
