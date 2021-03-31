extends Spatial


var sectors = {
	"mobility": {
		"dir": Vector2(2,2)
	},
	"private_engagement": {
		"dir": Vector2(2,0)
	},
	"energy": {
		"dir": Vector2(0,2)
	},
	"ernaehrung": {
		"start": Vector2(-2,-2),
		"dir": Vector2(-1,-1)
	},
	"public_engagement": {
		"dir": Vector2(-2,0)
	},
	"indirect_emissions": {
		"dir": Vector2(0,-2)
	}
}

func to_cube(vec2):
	var x = vec2.x
	var z = vec2.y
	var y = -x-z
	return Vector3(x,y,z)

func to_axial(cube):
	var q = cube.x
	var r = cube.z
	return Vector2(q, r)

func show_sector(sector):
	if !sectors.has(sector): return
	var dir = to_cube(sectors.get(sector).dir)
	var start = dir + dir
	#highlight(to_axial(start))
	_show_sector(start,dir)


func _show_sector(coord, dir):
	#print((coord), (dir))
#	if grid(to_axial(coord)):
#		_show_sector(coord+dir, dir)
#		_show_sector(coord+(dir + dir), dir)
#		_show_sector(coord+(dir + Vector3(1,0,0)), dir)
	for child in get_children():
		var string = child.name
		var parts = string.split(',')

		var current_coords = Vector2(parts[0].to_int(), parts[1].to_int())
		#print(dir, " ",current_coords)
		#if ( current_coords.x <= current_coords.y and current_coords.z > current_coords.y ):
		if !(current_coords.x in range(-2, 3) and current_coords.y in range(max(-2, -2 + current_coords.x), min(2, 2 + current_coords.x) + 1)):
			child.show_grid()

func grid(coords):  
	var hex = get_node(str(coords.x) +','+ str(coords.y))
	if hex != null:
		return hex.show_grid()
	return false

func highlight(coords):  
	var hex = get_node(str(coords.x) +','+ str(coords.y))
	if hex != null:
		hex.show_preview()
		return true
	return false

func show_grid():
	for child in get_children():
		child.show_grid()
		
func hide_grid():
	for child in get_children():
		child.hide()

