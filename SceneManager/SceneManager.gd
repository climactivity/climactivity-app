class_name SceneManager
extends Control

signal current_transition_finished

# scenes
export var start_scene = preload("res://ForestScene3d/ForestScene3d.tscn")
var home_scene
var bigpoint_scene = preload("res://Scenes/BigPointScene.tscn") 
var sector_data = preload("res://ForestScene3d/Tents/SectorData.gd").new()
var current_scene
var last_scene
var history = []
var scene_map = {
	"start_scene": start_scene, # forest view
	"loading_instance": preload("res://SceneManager/Loading.tscn"), # loading screen
	"big_point_scene": preload("res://Scenes/BigPointScene.tscn"),
	"quiz_scene": preload("res://Scenes/QuizScene.tscn"),
	"big_point_scene_consumption": preload("res://Scenes/BigPointScene.tscn"),
	"big_point_scene_energy": preload("res://Scenes/BigPointScene.tscn"),
	"big_point_scene_mobility": preload("res://Scenes/BigPointScene.tscn"),
	"big_point_scene_indirect_emissions": preload("res://Scenes/BigPointScene.tscn"),
	"big_point_scene_private_engagement": preload("res://Scenes/BigPointScene.tscn"),
	"big_point_scene_public_engagement": preload("res://Scenes/BigPointScene.tscn"),
	"water_collection_scene": preload("res://Scenes/WaterCollectionScene.tscn")
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

onready var overlay = $Overlay
onready var overlay_viewport = $Overlay/Viewport

#cool anims
onready var animation_player = $AnimationPlayer

var is_changing_scene = false

func _ready():
	GameManager.scene_manager = self
	_prepare_bigpoint_scenes()
	scene_map.water_collection_scene = preload("res://Scenes/WaterCollectionScene.tscn").instance()
	_show_A()
	current_scene = start_scene.instance()
	home_scene = current_scene
	A_viewport.add_child(current_scene)

func _prepare_bigpoint_scenes(): 
	scene_map.big_point_scene_consumption = _prepare_bigpoint_scene("ernaehrung")
	scene_map.big_point_scene_energy =  _prepare_bigpoint_scene("energy")
	scene_map.big_point_scene_mobility = _prepare_bigpoint_scene("mobility")
	scene_map.big_point_scene_indirect_emissions = _prepare_bigpoint_scene("indirect_emissions")
	scene_map.big_point_scene_private_engagement = _prepare_bigpoint_scene("private_engagement")
	scene_map.big_point_scene_public_engagement = _prepare_bigpoint_scene("public_engagement")

func _prepare_bigpoint_scene(sector):
	var new_instance = bigpoint_scene.instance() 
	new_instance.receive_navigation(sector_data.sector_data[sector])
	return new_instance

func go_home(): 
	push_scene(home_scene)

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
			if scene is PackedScene:
				scene = scene_map.get(scene).instance()
			else: 
				scene = scene_map.get(scene)
		else:
			Logger.print("Loading new scene: " + scene, self)
			scene = load(scene).instance()
	else:
		Logger.print("Reattaching scene: " + scene.name, self)
	last_scene = current_scene
	current_scene = scene
	Logger.print("Navigating: " + current_scene.name, self)
	A_viewport.add_child(scene)
	if (scene.has_method("receive_navigation") && navigation_data != null):
		Logger.print("Navigation data %s" % str(navigation_data), self)
		scene.receive_navigation(navigation_data)
	if (scene.has_method("_restored")): 
		scene._restored()
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
	if (scene.has_method("_restored")): 
		scene._restored()
	animation_player.play("Move_Back")

func _show_A():
	A.modulate.a = 1
	B.modulate.a = 0
	
func _show_B():
	B.modulate.a = 1
	A.modulate.a = 0

	
func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Reset"): return
	_show_A()
	if B_viewport.get_child_count() > 0:
		B_viewport.remove_child(last_scene)
	is_changing_scene = false
	get_tree().get_root().set_disable_input(false)
	emit_signal("current_transition_finished")
