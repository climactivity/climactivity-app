extends Spatial

export var should_move = false
export var parallax1_factor = 1.0
export var parallax2_factor = 2.0

# some backdrop elements can be really annoying in editor, so they are hidden in engine.
# get reenabled when the game starts
func _ready():
	for child in get_children(): 
		child.visible = true

# move backdrop with camera, offset based on which layer the element belongs to
func move(delta):
	if(!should_move): return
	self.global_translate(delta)
	for child in get_children(): 
	#	child.translate(Vector3(0.0,0.0,delta.z*-0.05))
		if child.is_in_group("Parallax"):
			child.translate(Vector3(parallax1_factor * (delta.x/child.transform.origin.z),0.0,0.0))
		elif child.is_in_group("Parallax2"):
			child.translate(Vector3(parallax2_factor * (delta.x/child.transform.origin.z),0.0,0.0))
