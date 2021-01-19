extends Spatial

#### templates

var sectors = {
	"ernährung": {
		"texture": preload("res://ForestScene3d/Tents/g1474.png"),
		"target_scene": "res://Scenes/BigPointScene.tscn",
		"navigation_data": {
			"sector": "ernaehrung",
			"sector_title": "Zelt der Ernährung",
			"sector_logo": preload("res://Assets/Icons/sector_icon_ern.png")
		}
	}
}

#### Instance vars
var was_initialized = false
var sector_name
var target_scene
var navigation_data
var texture = preload("res://ForestScene3d/Tents/g1474.png") setget set_sprite
onready var sprite = $Sprite3D
onready var tile = $MeshInstance

func init_at(for_sector = [""]):
	if(sectors.has(for_sector[0])):
		var init_params = sectors.get(for_sector[0])
		sector_name = for_sector[0]
		target_scene = init_params.get("target_scene")
		navigation_data = init_params.get("navigation_data")
		set_sprite(init_params.get("texture"))
		name = sector_name + "s Zelt"
		was_initialized = true

func _ready():
	if(!OS.is_debug_build()): tile.visible = false
	$Sprite3D.texture = texture

func set_sprite(new_texture):
	texture = new_texture
	$Sprite3D.texture = texture

func on_touch(): 
	print("hi")
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
