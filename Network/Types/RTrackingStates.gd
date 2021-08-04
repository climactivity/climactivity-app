extends Resource
class_name RTrackingStates
export (Dictionary) var tracking_states 
export (Array) var tracking_updates
export (int) var last_update = 0
export (Dictionary) var board_entites
export (Resource) var inventory
export (Dictionary) var completed_infobytes
export (Array) var current_quests 
export (Array) var completed_quests
#export (Dictionary) var level = {}

func _init():
	if current_quests == null: current_quests = []
	if completed_quests == null: completed_quests = []
	if tracking_updates == null: tracking_updates = []
	if tracking_states == null: tracking_states = {}
	if board_entites == null: board_entites = {}
	if completed_infobytes == null: completed_infobytes = {}

	if inventory == null: 
		inventory = load("res://Network/Types/RInventory.gd").new()

func from_dict(dict): 
	Logger.error("from_dict not impemented!", self)
	pass

func to_dict(): 
	var out = {
		"tracking_states": Util.flatten_dict(tracking_states),
		"tracking_updates": Util.flatten_array(tracking_updates),
		"last_update": last_update,
		"board_entites": Util.flatten_dict(board_entites),
		#"inventory": Util.flatten_dict(inventory.to_dict()),
		"completed_infobytes": Util.flatten_dict(completed_infobytes),
	#	"level": Util.flatten_dict(level)
		"current_quests": Util.flatten_array(current_quests),
		"completed_quests": Util.flatten_array(completed_quests)
	}
	#Logger.print(out)
	return out

func compact_updates(date, interval):
	pass

func to_json():
	return JSON.print(to_dict())

func _to_string():
	return JSON.print(to_dict())

func add_tracking_update(tracking_update):
	tracking_updates.push_front(tracking_update)

func add_reward(reward):
	inventory.add_reward(reward)

