extends CanvasLayer

var transition_start_point = Vector2.ZERO

var scene_path
onready var scene_mount_point: Node

var transition_anims = [
	"circle_fade",
	"swipe_right",
	"swipe_up"
]

func _init():
	pass

func _ready():
	scene_path = ProjectSettings.get_setting("application/run/main_scene")
	pass

func transition_to( anim = "circle_fade", scn_path = "res://MainScreen.tscn",  center = Vector2(0.5,0.5)):
	if scene_path == scn_path: 
		return
	scene_path = scn_path; 
	transition_start_point = center
	if anim == "circle_fade": 
		$CircleFade.material.set_shader_param("center", center)
	$AnimationPlayer.play(anim)
	#_change_scene()
	
func _change_scene(): 
	if scene_path != "": 
		#clear current scene 
		get_tree().change_scene(scene_path)

func set_center(target_node):
	transition_start_point = target_node.get_viewport_transform().origin
