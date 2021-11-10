extends Resource
class_name RBoardEntity
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
export (Vector2) var axial_coords
export (bool) var just_planted 
export (Vector2) var center_offset # in AABB (1.0,1.0),(-1.0,1-.0), how much the scene is acutally shifted is controlled by presentation layer
export (String) var aspect_id
export (int) var last_watered = 0

var current_water = 0.0

func _ready():
	if last_watered == 0: 
		last_watered = planted_at

func make_new(template, new_entity_id, new_aspect_id, initial_stage = 0, new_growth_period = 1 * Util.DAY): 
	tree_template = template
	entity_id = new_entity_id
	stage = initial_stage
	growth_period = new_growth_period
	#planted_at = OS.get_unix_time()
	aspect_id = new_aspect_id
	base_water_required = 12
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
	last_watered = OS.get_unix_time()
	emit_signal("getting_watered", old_water, water_applied)
	RewardService.add_xp(amount)
	Logger.print( "Added %2.4f water to %s" % [amount, entity_id], self)



func alert_can_water(): 
	if node == null: return
	if node.has_method("alert_can_water"):
		node.alert_can_water() 

func matured_at(): 
	return planted_at + growth_period

func is_mature(): 
	if !planted_at: 
		return false 
	return OS.get_unix_time() > planted_at + growth_period or stage >= 4

func to_dict(): 
	var out = {
		"_id" : _id,
		"last_sync" : last_sync,
		"stage" : stage,
		"growth_period" : growth_period,
		"planted_at" : planted_at,
		"water_applied" : water_applied,
		"base_water_required" : base_water_required,
		"water_required" : water_required,
		"tree_template" : tree_template._id,
		"axial_coords" : axial_coords,
		"just_planted" :  just_planted,
		"center_offset" :center_offset,  # in AABB (1.0,1.0),(-1.0,1-.0), how much the scene is acutally shifted is controlled by presentation layer
		"aspect_id" : aspect_id._id,
		"last_watered": last_watered
	}
	#Logger.print(out)
	return out

func from_dict(dict): 
	
#	var hm = str2var(dict["axial_coords"])
#	var a = var2str(Vector2(2,1))
#	print(typeof(a), a)
#	var b = str2var(a)
#	print(typeof(b),b )
#	print(typeof(hm), hm)
	self._id = dict["_id"]
	self.aspect_id = Api.get_aspect_by_name(dict["aspect_id"])
	self.axial_coords = Vector2(str2var("Vector2" + dict["axial_coords"]))
	self.base_water_required = dict["base_water_required"]
	self.center_offset = Vector2(str2var( "Vector2" + dict["center_offset"]))  # in AABB (1.0,1.0),(-1.0,1-.0), how much the scene is acutally shifted is controlled by presentation layer
	self.growth_period = dict["growth_period"] as int 
	self.just_planted =  dict["just_planted"]
	self.last_sync = dict["last_sync"]
	self.last_watered = int(dict["last_watered"])
	self.planted_at = int(dict["planted_at"])
	self.stage = int(dict["stage"])
	self.tree_template = TreeTemplateFactory.get_template(dict["tree_template"])
	self.water_applied = dict["water_applied"]
	self.water_required = dict["water_required"]
	return self
