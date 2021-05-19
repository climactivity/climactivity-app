class_name SceneManager
extends Control

signal current_transition_finished

enum LifecycleType {
	NEVER_CLOSE,
	ALWAYS_REINSTANCE,
	DEFAULT
}

# scenes
export (PackedScene) var start_scene 
export var _settings_scene = preload("res://Scenes/SettingsScene.tscn")
export var _notification_scene = preload("res://Scenes/NotificationsScene.tscn")
export var _social_scene = preload("res://Scenes/SocialScene.tscn")
export var _stats_scene = preload("res://Scenes/StatsScene.tscn")

var home_scene
var bigpoint_scene = preload("res://Scenes/BigPointScene.tscn") 
var sector_data = preload("res://ForestScene3d/Tents/SectorData.gd").new()
var current_scene
var last_scene
var history = []
var path_history = []
var current_path = ''
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

var lifecycle_data = {
	"start_scene": [LifecycleType.NEVER_CLOSE],
	"quiz_scene": [LifecycleType.ALWAYS_REINSTANCE]
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

## handle back button
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: # only works on android, ios doesn't have a back button
		var header = _get_focused_header()
		if header == null:
			pop_scene()
		if header.has_method("_on_BackButton_pressed"):
			header._on_BackButton_pressed() 

func _get_focused_header():
	if current_scene != null and current_scene.get("header") != null: 
		var current_header = current_scene.get("header")
		return current_header
	return null

func _setup_safe_area(): 
	var safe_area = OS.get_window_safe_area()
	OS.get_screen_dpi() * 90
	self.rect_position = safe_area.position 
	self.rect_size = safe_area.size * OS.get_screen_dpi() / 115
	
	Logger.print(safe_area, self)
	Logger.print(rect_size, self)
	Logger.print(rect_position, self)


func _ready():
#	_setup_safe_area()
	GameManager.scene_manager = self
	_prepare_bigpoint_scenes()
	_prepare_fixed_scenes()
	scene_map.water_collection_scene = preload("res://Scenes/WaterCollectionScene.tscn").instance()
	_show_A()
	loading_instance = loading_instance.instance()
	A.add_child(loading_instance)
	current_scene = start_scene.instance()
	current_scene.connect("ready",self,"_remove_splash")
#	yield(current_scene, "ready")
#	A.remove_child(loading_instance)
	home_scene = current_scene
	A_viewport.add_child(current_scene)

func _remove_splash(): 
	Logger.print("Main Scene loaded!", self)
	A.remove_child(loading_instance)

func _prepare_fixed_scenes():
	scene_map["settings_scene"] = _settings_scene.instance()
	scene_map["notifications_scene"] =  _notification_scene.instance()
	scene_map["social_scene"] =  _social_scene.instance()
	scene_map["stats_scene"] = _stats_scene.instance()

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

func go_home(config = TransitionFactory.MoveBack()): 
	push_scene(home_scene, {}, config)

func push_scene(scene, navigation_data = {}, config = TransitionFactory.MoveOut()) -> void: 
	if (is_changing_scene or _is_current_focus(scene)): return
	get_tree().get_root().set_disable_input(true)
	is_changing_scene = true
	A_viewport.remove_child(current_scene)
	B_viewport.add_child(current_scene)
	history.push_front(current_scene)
	path_history.push_front(current_path)
	_show_B()
	if (scene is String): 
		var new_instance
		current_path = scene
		if (scene_map.has(scene)):
			Logger.print("Rehydrating stored scene: " + scene, self)

			if scene is PackedScene:
				scene = scene_map.get(scene).instance()
			else: 
				scene = scene_map.get(scene)
		else:
			Logger.print("Loading new scene: " + scene, self)
			var _scene = load(scene)
			scene = _scene.instance()

	else:
		current_path = ''
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
	_update_menu_position()
	animation_player.play(config.transition_name)

func _update_menu_position(): 
	match current_path:
		"settings_scene": 
			GameManager.menu.set_navigation_state( MainMenu.Navigation_states.SETTINGS ,true)
		"notifications_scene":
			GameManager.menu.set_navigation_state( MainMenu.Navigation_states.NOTIFICATIONS ,true)
		"social_scene":
			GameManager.menu.set_navigation_state( MainMenu.Navigation_states.SOCIAL ,true)
		"stats_scene":
			GameManager.menu.set_navigation_state( MainMenu.Navigation_states.STATS ,true)
		_:
			return
	
func _is_current_focus(scene):
	if (scene is String): 
		return scene == current_path
	else:
		return scene == current_scene

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
	current_path = path_history.pop_front()
	_update_menu_position()
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
