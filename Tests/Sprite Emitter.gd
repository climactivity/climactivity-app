extends Control

export (Texture) var particle_texture
export (NodePath) var target
export var sprite_count = 30
export var sprites_per_second = 10
export var emit = true 
export (PackedScene) var particle_scene
var last_emitted
var emit_delta

func _ready(): 
	emit_delta = 1.0/sprites_per_second
	last_emitted = emit_delta
	
func _process(delta):
	last_emitted -= delta
	if last_emitted <= 0.0: 
		last_emitted = emit_delta 
		


func emit_particle(): 
	var new_particle = particle_scene.instance()
	
