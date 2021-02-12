extends Node

var player_state = PSS.get_player_state_ref()

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


func add_object():
	pass
	
func get_object(): 
	pass

func has_placeable_entity():
	return player_state.inventory.unplaced_items != null && player_state.inventory.unplaced_items.size() > 0

func flush():
	pass
	
