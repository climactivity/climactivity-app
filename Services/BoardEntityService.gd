extends Node

var player_state = PSS.get_player_state_ref()
var r_bp_tree_instance = preload("res://Network/Types/RBoardEntity.gd")

#var format = ".tres"
#var base_path = "user://board_entities"

func _init(): 
	pass
#	var dir =  Directory.new()
#	if !dir.dir_exists(base_path):
#		var err = dir.make_dir_recursive(base_path)
#		if err != OK:
#			Logger.print("Cannot create board entities dir at %s: %s" % [base_path, err], self)

func get_placed_objects():
	return player_state.board_entites


func add_entity(template, aspect):
	var new_entity = _new_board_entity_resource(template, aspect)
	PSS.add_item_to_inventory(new_entity)
	AspectTrackingService.consume_seedling(aspect._id, new_entity)
	return OK

func _new_board_entity_resource(template, aspect): 
	var id = Util.uuid_util.v4()
	var resource = r_bp_tree_instance.new()
	resource.make_new(template, id, aspect )
	return resource

func add_object():
	pass
	
func get_object(): 
	pass

func has_placeable_entity():
	return player_state.inventory.unplaced_items != null && player_state.inventory.unplaced_items.size() > 0

func get_placeable_entity(): 
	if has_placeable_entity():
		return player_state.inventory.unplaced_items[0]
	return null

func place_entity(entity, coordinates): 
	# update player state
	player_state.inventory.unplaced_items.erase(entity)
	player_state.board_entites[coordinates] = entity
	flush()
	# add scene
	return TreeTemplateFactory.rehydrate(entity)

func flush():
	PSS.flush()
	
