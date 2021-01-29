extends VBoxContainer

signal emit_option(option)

onready var http_request = $HTTPRequest
onready var question = $"kiko_avatar - placeholder"
onready var heading = $"PanelContainer/MarginContainer/VBoxContainer/Heading"
onready var options_holder = $"PanelContainer/MarginContainer/VBoxContainer/Options"
onready var select_button = $"MarginContainer/CenterContainer/SaveTrackingOptionButton"

var bp_option = preload("res://UI/Components/TrackingOption.tscn")
var tracking_data setget set_tracking_data
var ready = false
var title = "Heading not set!"
var selected_option setget set_option

func _on_set_tracking_level(new_level): 
	pass
	
func set_tracking_data(new_tracking_data): 
	tracking_data = new_tracking_data
	Logger.print("Aspect got data!", self)
	if ready: _show_data()
	
func set_title(new_title): 
	title = new_title
	if ready: heading.set_text(title)
	
func _ready(): 
	ready = true
	_show_data()
	heading.set_text(title)
	select_button.disabled = selected_option == null
	
func _show_data(): 
	if tracking_data == null: 
		Logger.print("Aspect missing data!", self)
		return
	question.set_text(tracking_data.question)
	#clear previous options if any
	for child in options_holder.get_children(): 
		options_holder.remove_child(child)
	#show options
	for option_data in tracking_data.options: 
		var new_option_instance = bp_option.instance()
		new_option_instance.set_checkbox_controller_path(options_holder.get_path())
		new_option_instance.set_tracking_option_data(option_data)
		new_option_instance.connect("selected", self, "set_option")
		
		options_holder.add_child(new_option_instance)
	
func set_option(option):
	selected_option = option
	select_button.text = "Speichern"
	print(option)
	select_button.disabled = false


func _on_SaveTrackingOptionButton_pressed():
	select_button.disabled = true
	select_button.text = "Gespeichert!"
	print(get_signal_connection_list("emit_option"))
	emit_signal("emit_option", selected_option.option_data)
