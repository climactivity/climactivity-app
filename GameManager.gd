extends Node

var cloud
var map
var camera
var scene_manager: SceneManager
var forest

func save_game(): 
	var save_data = {
		"install_id": OS.get_unique_id(),
		"player_data": PlayerController.save(),
		"forest_state": forest.save_forest_state(),
	}
	if (OS.is_debug_build()):
		Logger.print(JSON.print(save_data, "\t"), self)

