class_name SceneManager
extends Control

# scenes
export var start_scene = preload("res://MainScreen.tscn")
var current_scene
var last_scene
var history = []
var scene_map = {
	"start_scene": preload("res://MainScreen.tscn"), # forest view
	"loading_instance": preload("res://SceneManager/Loading.tscn"), # loading screen
	"big_point_scene": preload("res://UI/BigPointScreen.tscn"),
	"aspekt_scene": preload("res://UI/BigPointScreen.tscn"),
	"quiz_scene": preload("res://UI/BigPointScreen.tscn"),
}

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

var is_changing_scene = false

func _ready():
	GameManager.scene_manager = self
	_show_A()
	current_scene = start_scene.instance()
	A_viewport.add_child(current_scene)

func push_scene(scene, navigation_data = {}, config = TransitionFactory.MoveOut()) -> void: 
	if (is_changing_scene): return
	get_tree().get_root().set_disable_input(true)
	is_changing_scene = true
	A_viewport.remove_child(current_scene)
	B_viewport.add_child(current_scene)
	history.push_front(current_scene)
	_show_B()
	if (scene is String): 
		var new_instance
		if (scene_map.has(scene)):
			Logger.print("Rehydrating stored scene: " + scene, self)

			scene = scene_map.get(scene).instance()
		else:
			Logger.print("Loading new scene: " + scene, self)
			scene = load(scene).instance()
	else:
		Logger.print("Reattaching scene: " + scene.name, self)
	last_scene = current_scene
	current_scene = scene
	Logger.print("Navigating: " + current_scene.name, self)
	A_viewport.add_child(scene)
	if ("receive_navigation" in scene && navigation_data != null):
		Logger.print("Navigation data %s" % str(navigation_data), self)
		scene.receive_navigation(navigation_data)
	animation_player.play(config.transition_name)

func pop_scene(config = TransitionFactory.MoveBack()) -> void: 
	if (is_changing_scene): return
	if (history.empty()):
		Logger.print("History empty, cannot go back!", self)
		return
	get_tree().get_root().set_disable_input(true)
	A_viewport.remove_child(current_scene)
	B_viewport.add_child(current_scene)
	_show_B()
	var scene = history.pop_front()
	Logger.print("Reattaching scene: " + scene.name, self)
	A_viewport.add_child(scene)
	last_scene = current_scene
	current_scene = scene
	animation_player.play("Move_Back")

func _show_A():
	A.modulate.a = 1
	B.modulate.a = 0
	
func _show_B():
	B.modulate.a = 1
	A.modulate.a = 0

	
func _on_AnimationPlayer_animation_finished(anim_name):
	_show_A()
	B_viewport.remove_child(last_scene)
	is_changing_scene = false
	get_tree().get_root().set_disable_input(false)
	
