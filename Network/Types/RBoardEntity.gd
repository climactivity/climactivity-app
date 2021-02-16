extends Resource

export (String) var entity_id
export (String) var _id
export (String) var last_sync
export (String) var stage
export (int) var growth_period
export (float) var water_applied
export (float) var base_water_required
export (float) var water_required
export (Resource) var tree_template
export (Vector3) var axial_coords
export (Vector2) var center_offset # in AABB (1.0,1.0),(-1.0,1-.0), how much the scene is acutally shifted is controlled by presentation layer

func make_new(template, new_entity_id, initial_stage = 0, new_growth_period = 1 * Util.DAY): 
	tree_template = template
	entity_id = new_entity_id
	stage = initial_stage
	growth_period = new_growth_period
	_calculate_offset()

func last_sync():
	if _id == null:
		return -1
	else:
		return last_sync

func _calculate_offset(): 
	center_offset = Vector2(rand_range(-1.0,1.0), rand_range(-1.0, 1.0))

