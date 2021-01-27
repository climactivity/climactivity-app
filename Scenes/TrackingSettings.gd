extends Control

onready var http_request = $HTTPRequest
onready var heading = $"kiko_avatar - placeholder"
onready var options_holder = $"PanelContainer/MarginContainer/VBoxContainer/Options"
var bp_option = preload("res://UI/Components/TrackingOption.tscn")
var tracking_data setget set_tracking_data
var ready = false
func _on_set_tracking_level(new_level): 
	pass
	
func set_tracking_data(new_tracking_data): 
	tracking_data = new_tracking_data
	Logger.print("Aspect got data!", self)
	if ready: _show_data()
	
func _ready(): 
	ready = true
	_show_data()

func _show_data(): 
	if tracking_data == null: 
		Logger.print("Aspect missing data!", self)
		return
	heading.set_text(tracking_data.question)
	#clear previous options if any
	for child in options_holder.get_children(): 
		options_holder.remove_child(child)
	#show options
	for option_data in tracking_data.options: 
		var new_option_instance = bp_option.instance()
		new_option_instance.set_tracking_option_data(option_data)
		options_holder.add_child(new_option_instance)
	
