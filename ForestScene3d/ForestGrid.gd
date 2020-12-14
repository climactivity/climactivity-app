extends Spatial

const y_zero = 0.002

var HexGrid = preload("./HexGrid.gd").new()
var template = preload("res://ForestScene3d/EmptyHex.tscn")
var tileMesh = preload("res://ForestScene3d/EmptyHex.tscn")
var treeScene = preload("res://ForestScene3d/TestTree3d.tscn")

var placeables = {
	"base_tree": preload("res://ForestScene3d/BaseTree.tscn")
}

var placed_objects = {}

export var SIZE = 34

onready var cursor = $Cursor

func _ready(): 
	#HexGrid.set_hex_scale(Vector2(3,3))
	var centerTile = HexGrid.get_hex_at(Vector2(0.0,0.0))
	#_tile_area(centerTile, SIZE, tileMesh)

func _tile_area(tile, limit, tileMeshF): 
	var tiles = tile.get_all_within2(limit)
	for tile in tiles: 
		var plane_pos = HexGrid.get_hex_center(tile)
		var hex_mesh = tileMeshF.instance()
		add_child(hex_mesh)
		hex_mesh.translation.x = plane_pos.x
		hex_mesh.translation.z = plane_pos.y	

func _on_HexGrid_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	# It's called click_position, but you don't need to click
	var plane_coords = self.transform.affine_inverse() * click_position
	plane_coords = Vector2(plane_coords.x, plane_coords.z)
	if event is InputEventMouse:
		if event.is_pressed() &&  event.button_index == BUTTON_RIGHT:
			# Display the coords used
			
			var selected_hex = HexGrid.get_hex_at(plane_coords)
			var plane_pos = HexGrid.get_hex_center(HexGrid.get_hex_at(plane_coords))
			var selected_placeable = "base_tree"
			print("Plane coords: ", str(plane_coords))
			print("Hex coords: ",   str(selected_hex.axial_coords))
			
			if(_can_place(selected_hex, selected_placeable)):
				var new_object = placeables[selected_placeable].instance()
				add_child(new_object)
				new_object.translation.x = plane_pos.x
				new_object.translation.y = y_zero # prevent z-fighting
				new_object.translation.z = plane_pos.y	
				placed_objects[selected_hex.axial_coords] = new_object

func _can_place(hex, action): 
	var x = hex.axial_coords.x
	var y = hex.axial_coords.y
	if x in range(-SIZE, SIZE+1) && y in range(max(-SIZE, -SIZE + x), min(SIZE, SIZE + x) + 1):
		return true


func to_json() -> String:
	var save_dict = {}
	for key in placed_objects.keys():
		save_dict[key] = placed_objects.get(key).save()
	return JSON.print(save_dict, "\t")
