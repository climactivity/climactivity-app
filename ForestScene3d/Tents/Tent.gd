extends Spatial

#### templates

var sectors = {
	"ernährung": {
		"texture": preload("res://Assets/sketch/zelt_neu/zelt_gruen_ZU.png"),
		"texture_open": preload("res://Assets/sketch/zelt_neu/zelt_gruen_AUF.png"),
		"target_scene": "res://Scenes/BigPointScene.tscn",
		"left_facing": true,
		"sector_color": Color('#97e831'),
		"navigation_data": {
			"sector": "ernaehrung",
			"sector_title": "Zelt der Ernährung",
			"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Ernaehrung.png"),
		}
	},
	"energy": {
		"texture": preload("res://Assets/sketch/zelt_neu/zelt_rot_ZU.png"),
		"texture_open": preload("res://Assets/sketch/zelt_neu/zelt_rot_AUF.png"),
		"target_scene": "res://Scenes/BigPointScene.tscn",
		"left_facing": false,
		"sector_color": Color('#E40045'),
		"navigation_data": {
			"sector": "energy",
			"sector_title": "Zelt der Energie",
			"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Energie.png")
		}
	},
	"mobility": {
		"texture": preload("res://Assets/sketch/zelt_neu/zelt_gelb_ZU.png"), 
		"texture_open": preload("res://Assets/sketch/zelt_neu/zelt_gelb_AUF.png"),
		"target_scene": "res://Scenes/BigPointScene.tscn", 
		"left_facing": false,
		"sector_color": Color('#E6A718'),     #E6A7183
		"navigation_data": {
			"sector": "mobility",
			"sector_title": "Zelt der Mobilität",
			"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Mobilitaet.png")
		}
	},
	"indirect_emissions": {
		"texture": preload("res://Assets/sketch/zelt_neu/zelt_lila_ZU.png"),
		"texture_open": preload("res://Assets/sketch/zelt_neu/zelt_lila_AUF.png"),
		"target_scene": "res://Scenes/BigPointScene.tscn",
		"left_facing": false,
		"sector_color": Color('#A75177'),
		"navigation_data": {
			"sector": "indirect_emissions",
			"sector_title": "Zelt des Konsums",
			"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Konsum.png")
		}
	},
	"private_engagement": {
		"texture": preload("res://Assets/sketch/zelt_neu/zelt_hellblau_ZU.png"),
		"texture_open": preload("res://Assets/sketch/zelt_neu/zelt_hellblau_AUF.png"),
		"target_scene": "res://Scenes/BigPointScene.tscn",
		"left_facing": true,
		"sector_color": Color('#599DBB'),
		"navigation_data": {
			"sector": "private_engagement",
			"sector_title": "Zelt der privaten Aktivität",
			"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Engage_Privat.png")
		}
	},
	"public_engagement": {
		"texture": preload("res://Assets/sketch/zelt_neu/zelt_dunkelblau_ZU.png"),
		"texture_open": preload("res://Assets/sketch/zelt_neu/zelt_dunkelblau_AUF.png"),
		"target_scene": "res://Scenes/BigPointScene.tscn",
		"left_facing": true,
		"sector_color": Color('#37647A'),
		"navigation_data": {
			"sector": "public_engagement",
			"sector_title": "Zelt der gesellschaftlichen Aktivität",
			"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Engage_Gesellschaft.png")
		}
	},
}

#### Instance vars
var was_initialized = false
var sector_name
var target_scene
var navigation_data
var texture = preload("res://Assets/sketch/zelt_neu/zelt_rot_ZU.png") setget set_sprite
var left_facing = false
onready var sprite = $Sprite3D
onready var tile = $MeshInstance
var init_params
func init_at(for_sector = [""]):
	if(sectors.has(for_sector[0])):
		init_params = sectors.get(for_sector[0])
		sector_name = for_sector[0]
		target_scene = init_params.get("target_scene")
		navigation_data = init_params.get("navigation_data")
		set_sprite(init_params.get("texture"))
		name = sector_name + "s Zelt"
		was_initialized = true
#		_set_icon(navigation_data["sector_logo"], init_params["left_facing"])

func _show_progress_ui():
	$AnimationPlayer.play("show_progress")
	
func _hide_progress_ui(): 
	$AnimationPlayer.play_backwards("show_progress")
	
func _set_icon(icon, facing_left):
	$Icon.texture = icon
	if !facing_left:
		$Icon.translate(Vector3( -2.0, 0.0, 0.0))

func _ready():
	if(!OS.is_debug_build()): tile.visible = false
	$Sprite3D.texture = texture
	$SpatialUIPanel.get_widget_instance().set_sector_data(init_params)
	GameManager.camera.connect("entity_focused", self, "_hide_progress_ui" )
	GameManager.camera.connect("entity_unfocused", self, "_show_progress_ui" )
func set_sprite(new_texture):
	texture = new_texture
	$Sprite3D.texture = texture

func on_touch(): 
	#
	if not was_initialized: 
		Logger.error("Not initialized!", self)
		return
	#return
	Logger.print("Navigating to " + str(target_scene) + " with " + str(navigation_data), self)
	if !(is_instance_valid(GameManager) and is_instance_valid(GameManager.scene_manager)): 
		Logger.error("App navigation not initialized!", self)
		return
	GameManager.scene_manager.push_scene(target_scene, navigation_data)

func save():
	return false

var last_pos = Vector2.ZERO
func _on_Collider_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed: 
		last_pos = event.position
	if event is InputEventMouseButton and !event.pressed: 
		var r = nc.get("ui/3dClicKAcceptanceRadius") if nc.get("ui/3dClicKAcceptanceRadius") != null else 5.0
		if (event.position - last_pos).length() < r:
			call_deferred('on_touch')
		else:
			print( (event.position - last_pos).length() ) 
