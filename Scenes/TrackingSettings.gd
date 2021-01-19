extends Control

onready var http_request = $HTTPRequest

var tracking_data setget set_tracking_data

func _on_set_tracking_level(new_level): 
	pass
	
func set_tracking_data(new_tracking_data): 
	tracking_data = new_tracking_data
	
