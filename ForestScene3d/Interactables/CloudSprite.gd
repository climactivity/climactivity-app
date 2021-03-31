tool
extends Sprite

export (float, 0.0, 1.0) var fill_state  = 0.0 setget set_fill_state, get_fill_state


func set_fill_state(new_state): 
	fill_state = new_state
	material.set("shader_param/fill_state", fill_state)
	if $Droplet == null: return
	$Droplet.visible = fill_state > 0.0
	
func get_fill_state(): 
	return fill_state
