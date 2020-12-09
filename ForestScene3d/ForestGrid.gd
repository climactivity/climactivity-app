extends Spatial

var HexGrid = preload("./HexGrid.gd").new()
var template = preload("res://ForestScene3d/EmptyHex.tscn")

onready var cursor = $Cursor


func _on_HexGrid_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	# It's called click_position, but you don't need to click
	var plane_coords = self.transform.affine_inverse() * click_position
	plane_coords = Vector2(plane_coords.x, plane_coords.z)
	if event is InputEventMouse:
		if event.is_pressed():
			# Display the coords used
			print("Plane coords: ", str(plane_coords))
			print("Hex coords: ",   str(HexGrid.get_hex_at(plane_coords).axial_coords))
			if cursor != null:
				var plane_pos = HexGrid.get_hex_center(HexGrid.get_hex_at(plane_coords))
				cursor.translation.x = plane_pos.x
				cursor.translation.z = plane_pos.y
				var hex_mesh = template.instance()
				add_child(hex_mesh)
				hex_mesh.translation.x = plane_pos.x
				hex_mesh.translation.z = plane_pos.y	
