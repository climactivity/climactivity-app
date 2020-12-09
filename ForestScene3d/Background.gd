extends Spatial

export var should_move = false
export var parallax1_factor = 1.0
export var parallax2_factor = 2.0
func move(delta):
	if(!should_move): return
	self.global_translate(delta)
	for child in get_children(): 
		if child.is_in_group("Parallax"):
			child.translate(Vector3(parallax1_factor * (delta.x/child.transform.origin.z),0.0,0.0))
		elif child.is_in_group("Parallax2"):
			child.translate(Vector3(parallax2_factor * (delta.x/child.transform.origin.z),0.0,0.0))
