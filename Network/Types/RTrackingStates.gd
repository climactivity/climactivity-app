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

func restore(nk_collection): 
	for json in nk_collection: 
		var object = JSON.parse(json).result
		if object.has("board_entites"):
			board_entites = {} 
			var _board_entites = object.board_entites
			for _entity in _board_entites:
				var entity = RBoardEntity.new()
				entity.from_dict(_board_entites[_entity])
				board_entites[entity.axial_coords] = entity
		if object.has("tracking_states"):
			tracking_states = {} #### ----- TODO ab hier
			var _tracking_states = object.tracking_states
			for _entity in _tracking_states:
				var entity = RTrackingState.new()
				entity.from_dict(_tracking_states[_entity])
				tracking_states[entity.aspect] = entity
#		if object.has("tracking_updates"):
#			board_entites = {} 
#			var _board_entites = object.board_entites
#			for _entity in _board_entites:
#				var entity = RBoardEntity.new()
#				entity.from_dict(_board_entites[_entity])
#				board_entites[entity.axial_coords] = entity	
#		if object.has("inventory"):
#			board_entites = {} 
#			var _board_entites = object.board_entites
#			for _entity in _board_entites:
#				var entity = RBoardEntity.new()
#				entity.from_dict(_board_entites[_entity])
#				board_entites[entity.axial_coords] = entity	
#		if object.has("completed_infobytes"):
#			board_entites = {} 
#			var _board_entites = object.board_entites
#			for _entity in _board_entites:
#				var entity = RBoardEntity.new()
#				entity.from_dict(_board_entites[_entity])
#				board_entites[entity.axial_coords] = entity	
#		if object.has("current_quests"):
#			board_entites = {} 
#			var _board_entites = object.board_entites
#			for _entity in _board_entites:
#				var entity = RBoardEntity.new()
#				entity.from_dict(_board_entites[_entity])
#				board_entites[entity.axial_coords] = entity	
#		if object.has("completed_quests"):
#			board_entites = {} 
#			var _board_entites = object.board_entites
#			for _entity in _board_entites:
#				var entity = RBoardEntity.new()
#				entity.from_dict(_board_entites[_entity])
#				board_entites[entity.axial_coords] = entity

func to_dict(): 
	var out = {
		"tracking_states": Util.flatten_dict(tracking_states),
		"tracking_updates": Util.flatten_array(tracking_updates),
		"last_update": last_update,
		"board_entites": Util.flatten_dict(board_entites),
		"inventory": Util.flatten_dict(inventory.to_dict()),
		"completed_infobytes": Util.flatten_dict(completed_infobytes),
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

