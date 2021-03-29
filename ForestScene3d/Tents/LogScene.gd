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

func _ready():
	_set_sprite()

func init_at(params = [Vector2(0,0)]): 
	if is_instance_valid(Logger): 
		Logger.print("Placed log at %s" % params, self)
	if params[0].x > 0 || params[0] == Vector2(-1,-1): 
		$Sprite3D.flip_h = true 


func set_facing(log_facing): 
	facing = log_facing
	_set_sprite()

func _set_sprite():
	if !textures.has(facing):
		print("No texture for %s" + str(facing), self)
		return
	$Sprite3D.set_texture(textures.get(facing))

