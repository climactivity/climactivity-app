extends Control

onready var http_request = $HTTPRequest

var tracking_level_data setget set_tracking_level_data

func _on_set_tracking_level(new_level): 
	pass
	
func set_tracking_level_data(new_tracking_level_data): 
	tracking_level_data = new_tracking_level_data
	
