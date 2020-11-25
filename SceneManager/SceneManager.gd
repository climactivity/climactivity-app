extends Control

# scenes
export var start_scene = preload("res://MainScreen.tscn")
var current_scene
var history = []

#loading with progress bar
export var loading_instance = preload("res://SceneManager/Loading.tscn")
var loader
var wait_frames
var loading_node
var next_resource
var time_max = 100 #ms

#Scene Containers 
onready var A = $A
onready var A_viewport = $A/Viewport
onready var B = $B
onready var B_viewport = $B/Viewport

#cool anims
onready var animation_player = $AnimationPlayer

func _ready():
	_show_A()
	current_scene = start_scene.instance()
	A_viewport.add_child(current_scene)

func push_scene(scene, config: SceneTransitionConfig = SceneTransitionConfig.new()) -> void: 
	A_viewport.remove_child(current_scene)
	B_viewport.add_child(current_scene)
	_show_B()
	A_viewport.add_child(scene)
	history.push_front(current_scene)
	current_scene = scene
	animation_player.play(config.transition_name)


func _show_A():
	A.modulate.a = 1
	B.modulate.a = 0
	
func _show_B():
	B.modulate.a = 1
	A.modulate.a = 0