extends Spatial

export var should_move = false

func move(delta):
	if(!should_move): return
	self.global_translate(delta)
