"""
Based on https://github.com/romlok/godot-gdhexgrid
"""

extends Reference

var HexCell = preload("./HexCell.gd")
# Duplicate these from HexCell for ease of access
const DIR_N = Vector3(0, 1, -1)
const DIR_NE = Vector3(1, 0, -1)
const DIR_SE = Vector3(1, -1, 0)
const DIR_S = Vector3(0, -1, 1)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_NW = Vector3(-1, 1, 0)
const DIR_ALL = [DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW, DIR_NW]

# Allow the user to scale the hex for fake perspective or somesuch
export(Vector2) var hex_scale = Vector2(1, 1) setget set_hex_scale

var base_hex_size = Vector2(sqrt(3)/2, 1)
var hex_size
var hex_transform
var hex_transform_inv
# Pathfinding obstacles {Vector2: cost}
# A zero cost means impassable
var path_obstacles = {}
# Barriers restrict traversing between edges (in either direction)
# costs for barriers and obstacles are cumulative, but impassable is impassable
# {Vector2: {DIR_VECTOR2: cost, ...}}
var path_barriers = {}
var path_bounds = Rect2()
var path_cost_default = 1.0

func _init():
	set_hex_scale(hex_scale)

func set_hex_scale(scale):
	# We need to recalculate some stuff when projection scale changes
	hex_scale = scale
	hex_size = base_hex_size * hex_scale
	hex_transform = Transform2D(
		Vector2(hex_size.x, 0.0),
		Vector2(-hex_size.x / 2.0, -hex_size.y * 3.0/4.0),
		Vector2(0, 0)
	)
	#hex_transform = Transform2D(
	#	Vector2(hex_size.x * 3/4, -hex_size.y / 2),
	#	Vector2(0, -hex_size.y),
	#	Vector2(0, 0)
	#)
	hex_transform_inv = hex_transform.affine_inverse()

"""
Converting between hex-grid and 2D spatial coordinates
"""

func get_hex_center(hex):
	# Returns hex's centre position on the projection plane
	hex = HexCell.new(hex)
	return hex_transform * hex.axial_coords
	
func get_hex_at(coords):
	# Returns a HexCell at the given Vector2/3 on the projection plane
	# If the given value is a Vector3, its x,z coords will be used
	if typeof(coords) == TYPE_VECTOR3:
		coords = Vector2(coords.x, coords.z)
	return HexCell.new(hex_transform_inv * coords)
	
func get_hex_center3(hex, y=0):
	# Returns hex's centre position as a Vector3
	var coords = get_hex_center(hex)
	return Vector3(coords.x, y, coords.y)
