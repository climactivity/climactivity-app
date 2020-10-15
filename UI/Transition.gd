extends CanvasLayer

var transition_start_point = Vector2.ZERO

var scene_path
onready var scene_mount_point 

var transition_anims = [
	"circle_fade",
	"swipe_right",
	"swipe_up"
]

func _init():
	pass

func _ready():
	pass

func transition_to(scn_path, anim = "circle_fade"):
	scene_path = scn_path; 
	$AnimationPlayer.play(anim)
	
func _change_scene(): 
	if scene_path != "": 
		get_tree().change_scene(scene_path)

func set_center(target_node):
	transition_start_point = target_node.get_viewport_transform().origin
