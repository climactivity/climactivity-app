extends Spatial

const y_zero = 0.02

var HexGrid = preload("./HexGrid.gd").new()
var template = preload("res://ForestScene3d/EmptyHex.tscn")
var tileMesh = preload("res://ForestScene3d/EmptyHex.tscn")
var treeScene = preload("res://ForestScene3d/TestTree3d.tscn")

#var tree_template_factory = preload("res://ForestScene3d/TreeTemplates/TreeTemplateFactory.gd").new()

var placeables = {
	"base_tree": preload("res://ForestScene3d/TreeTemplates/BaseTree.tscn"),
	"tent_scene": preload("res://ForestScene3d/Tents/Tent.tscn")
}

var fixed_obejcts = {
	Vector2(1,1): {
		"scene": placeables["tent_scene"],
		"params": ["ernährung"]
	},
	Vector2(1,0): {
		"scene": placeables["tent_scene"],
		"params": ["ernährung"]
	},
	Vector2(0,1): {
		"scene": placeables["tent_scene"],
		"params": ["ernährung"]
	},
	Vector2(-1,-1): {
		"scene": placeables["tent_scene"],
		"params": ["ernährung"]
	},
	Vector2(-1,0): {
		"scene": placeables["tent_scene"],
		"params": ["ernährung"]
	},
	Vector2(0,-1): {
		"scene": placeables["tent_scene"],
		"params": ["ernährung"]
	},
}

var placed_objects = {}

var not_placeable_hexes
var MIN_RING = 3
export var SIZE = 34
export (Vector2) var hex_size_override = Vector2(1.0,1.0) setget set_scale
onready var cursor = $Cursor

var can_interact

func set_scale(new_scale):
	hex_size_override = new_scale
	HexGrid.set_hex_scale(hex_size_override)

func _place_fixed_objects(): 
	for axial_coords in fixed_obejcts.keys():
		var object_data = fixed_obejcts.get(axial_coords)
		var new_object = object_data.get("scene").instance()
		new_object.init_at(object_data.get("params"))
		_place_object_at(axial_coords, new_object, true)

func _ready(): 
	#if (is_instance_valid(GameManager) and is_instance_valid(GameManager.camera)): 
		#GameManager.camera.connect("consuming_gesture", self, "_enable_interaction")
		#GameManager.camera.connect("release_gesture", self, "_disable_interaction")
	HexGrid.set_hex_scale(hex_size_override)
	var centerTile = HexGrid.get_hex_at(Vector2(0.0,0.0))
	not_placeable_hexes = centerTile.get_all_within2(2)
	#_tile_area(centerTile, SIZE, treeScene)
	_place_fixed_objects()

func _enable_interaction(): 
	#print("camera released focus")
	can_interact = true
	
func _disable_interaction():
	#print("camera has focus")
	can_interact = false
	
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
	if (event is InputEventScreenDrag):
		if (event.relative.length() > 2): 
			print(event.relative)
			can_interact = false
		return
	if event is InputEventMouseButton:

		#print(can_interact)
		if event.is_pressed() && event.button_index == BUTTON_LEFT:
			can_interact = true
		if !event.is_pressed() && event.button_index == BUTTON_LEFT && can_interact:
			var selected_hex = HexGrid.get_hex_at(plane_coords)
			if(placed_objects.has(selected_hex.axial_coords)):
				var interacted_object = placed_objects.get(selected_hex.axial_coords)
				if(interacted_object.has_method("on_touch")):
					# interacted_object.on_touch()
					interacted_object.call_deferred("on_touch")

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_F and event.is_pressed()):
		placed_objects.get(Vector2(0,1)).on_touch()

func _place_object_at(axial_coords, instance, scale = false):
	Logger.print("Placing " + instance.name + " at " + str(axial_coords), self)
	var plane_pos = HexGrid.get_hex_center(axial_coords)
	add_child(instance)
	instance.translation.x = plane_pos.x
	instance.translation.y = y_zero # prevent z-fighting
	instance.translation.z = plane_pos.y	
	if(scale): instance.scale = Vector3(hex_size_override.x, hex_size_override.x, hex_size_override.y)
	placed_objects[axial_coords] = instance

func place_object(position, template_name): 
	var plane_coords = self.transform.affine_inverse() * position
	plane_coords = Vector2(plane_coords.x, plane_coords.z)
	var selected_hex = HexGrid.get_hex_at(plane_coords)
	var plane_pos = HexGrid.get_hex_center(HexGrid.get_hex_at(plane_coords))
	var selected_placeable = template_name
	if(can_place(selected_hex, selected_placeable)):
		var new_object = TreeTemplateFactory.make_new(template_name)
		_place_object_at(selected_hex.axial_coords, new_object, true)

func can_place(hex, instance): 
	var x = hex.axial_coords.x
	var y = hex.axial_coords.y
	if x in range(-SIZE, SIZE+1) && y in range(max(-SIZE, -SIZE + x), min(SIZE, SIZE + x) + 1):
		if !(abs(x) >= MIN_RING || abs(y) >= MIN_RING): 
			#print("can't place at: ", x,", ",y, "; ", "Blocked by min dist from center")
			return false
		if (placed_objects.has(hex.axial_coords)):
			print("can't place at: ", x,", ",y, "; ", "Blocked by placed object")
			return false
		#print("can place at: ", x,", ",y)
		return true
		

		
func can_drop(pos, action): 
	var plane_coords = _3d_to_plane_coords(pos)
	can_place(_plane_to_hex(plane_coords), action)

func _plane_to_hex(pos):
	return HexGrid.get_hex_at(pos)

func _3d_to_plane_coords(pos3d):
	var plane_coords = self.transform.affine_inverse() * pos3d
	return Vector2(plane_coords.x, plane_coords.z)

func to_dict() -> String:
	var save_dict = {}
	for key in placed_objects.keys():
		var object_to_save =  placed_objects.get(key)
		if( object_to_save.has_method("save")): 
			var object_data = object_to_save.save()
			if(object_data):
				save_dict[key] = object_data
		else:
			Logger.error("Object " + object_to_save.name + " has no save method!")
	return save_dict