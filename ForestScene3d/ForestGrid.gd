extends Spatial

const y_zero = 0.002

var HexGrid = preload("./HexGrid.gd").new()
var template = preload("res://ForestScene3d/EmptyHex.tscn")
var tileMesh = preload("res://ForestScene3d/EmptyHex.tscn")
var treeScene = preload("res://ForestScene3d/TestTree3d.tscn")

var tree_template_factory = preload("res://ForestScene3d/TreeTemplates/TreeTemplateFactory.gd").new()

var placeables = {
	"base_tree": preload("res://ForestScene3d/TreeTemplates/BaseTree.tscn")
}

var placed_objects = {}

export var SIZE = 34
export (Vector2) var hex_size_override = Vector2(1.0,1.0) setget set_scale
onready var cursor = $Cursor

func set_scale(new_scale):
	hex_size_override = new_scale
	HexGrid.set_hex_scale(hex_size_override)

func _ready(): 
	HexGrid.set_hex_scale(hex_size_override)
	var centerTile = HexGrid.get_hex_at(Vector2(0.0,0.0))
	_tile_area(centerTile, SIZE, treeScene)

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
			
			if(can_place(selected_hex, selected_placeable)):
				
				#var new_object = placeables[selected_placeable].instance()
				var new_object = tree_template_factory.make_new("tree0")
				add_child(new_object)
				new_object.translation.x = plane_pos.x
				new_object.translation.y = y_zero # prevent z-fighting
				new_object.translation.z = plane_pos.y	
				placed_objects[selected_hex.axial_coords] = new_object

func place_object(position, template_name): 
	var plane_coords = self.transform.affine_inverse() * position
	plane_coords = Vector2(plane_coords.x, plane_coords.z)
	var selected_hex = HexGrid.get_hex_at(plane_coords)
	var plane_pos = HexGrid.get_hex_center(HexGrid.get_hex_at(plane_coords))
	var selected_placeable = template_name
	if(can_place(selected_hex, selected_placeable)):
		
		#var new_object = placeables[selected_placeable].instance()
		var new_object = tree_template_factory.make_new(template_name)
		add_child(new_object)
		new_object.translation.x = plane_pos.x
		new_object.translation.y = y_zero # prevent z-fighting
		new_object.translation.z = plane_pos.y	
		#new_object.scale = Vector3(hex_size_override.x, hex_size_override.x, hex_size_override.y)
		placed_objects[selected_hex.axial_coords] = new_object

func can_place(hex, action): 
	var x = hex.axial_coords.x
	var y = hex.axial_coords.y
	if x in range(-SIZE, SIZE+1) && y in range(max(-SIZE, -SIZE + x), min(SIZE, SIZE + x) + 1):
		return true

func can_drop(pos, action): 
	var plane_coords = _3d_to_plane_coords(pos)
	can_place(_plane_to_hex(plane_coords), action)

func _plane_to_hex(pos):
	return HexGrid.get_hex_at(pos)

func _3d_to_plane_coords(pos3d):
	var plane_coords = self.transform.affine_inverse() * pos3d
	return Vector2(plane_coords.x, plane_coords.z)

func to_json() -> String:
	var save_dict = {}
	for key in placed_objects.keys():
		save_dict[key] = placed_objects.get(key).save()
	return JSON.print(save_dict, "\t")
