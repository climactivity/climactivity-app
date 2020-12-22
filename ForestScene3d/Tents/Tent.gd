extends Spatial

#### templates

var sectors = {
	"ernährung": {
		"texture": preload("res://ForestScene3d/Tents/g1474.png"),
		"target_scene": "big_point_scene",
		"navigation_data": {
			"sector": "ernährung"
		}
	}
}

#### Instance vars
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

func _ready():
	if(!OS.is_debug_build()): tile.visible = false
	$Sprite3D.texture = texture

func set_sprite(new_texture):
	texture = new_texture
	$Sprite3D.texture = texture

func on_touch(): 
	Logger.print("Navigating to " + target_scene, self)
	#GameManager.scene_manager.push_scene(target_scene)

func save():
	return false
