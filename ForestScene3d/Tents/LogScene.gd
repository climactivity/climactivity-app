tool extends Spatial

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
export (Texture) var person_tex = preload("res://Assets/sketch/character01.png") setget set_person_tex

func _ready():
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

func set_person_tex(new_tex):
	person_tex = new_tex
	_set_sprite()

func set_facing(log_facing): 
	facing = log_facing
	_set_sprite()

func _set_sprite():
	if !textures.has(facing):
		print("No texture for %s" + str(facing), self)
		return
	if $Sprite3D != null:
		$Sprite3D.set_texture(textures.get(facing))
		$Sprite3D.visible = show_log
	if person_tex != null and $SittingPlace/Person != null: 
		$SittingPlace/Person.set_texture(person_tex)
		$SittingPlace/Person.visible = show_person
