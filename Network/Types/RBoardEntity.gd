extends Resource

signal getting_watered(from, to)

var node = null

export (String) var entity_id
export (String) var _id
export (String) var last_sync
export (String) var stage
export (int) var growth_period
export (int) var planted_at
export (float) var water_applied
export (float) var base_water_required
export (float) var water_required
export (Resource) var tree_template
export (Vector3) var axial_coords
export (bool) var just_planted 
export (Vector2) var center_offset # in AABB (1.0,1.0),(-1.0,1-.0), how much the scene is acutally shifted is controlled by presentation layer
export (String) var aspect_id

var current_water = 0.0

func make_new(template, new_entity_id, new_aspect_id, initial_stage = 0, new_growth_period = 1 * Util.DAY): 
	tree_template = template
	entity_id = new_entity_id
	stage = initial_stage
	growth_period = new_growth_period
	planted_at = OS.get_unix_time()
	aspect_id = new_aspect_id
	base_water_required = 100
	water_required = base_water_required * (new_growth_period / Util.DAY)
	just_planted = true
	_calculate_offset()

func last_sync():
	if _id == null:
		return -1
	else:
		return last_sync

func _calculate_offset(): 
	center_offset = Vector2(rand_range(-1.0,1.0), rand_range(-1.0, 1.0))

func consume_water(amount: float):
	var old_water = water_applied
	water_applied += amount
	current_water = amount
	emit_signal("getting_watered", old_water, water_applied)
	Logger.print( "Added %2.4f water to %s" % [amount, entity_id], self)

func alert_can_water(): 
	if node == null: return
	if node.has_method("alert_can_water"):
		node.alert_can_water() 
