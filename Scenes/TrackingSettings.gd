extends VBoxContainer

signal emit_option(option, aspect)

onready var http_request = $HTTPRequest
onready var question = $"MarginContainer2/kiko_avatar - placeholder"
onready var heading = $"CySidePanel"
onready var options_holder = $"CySidePanel/Options"
onready var select_button = $"MarginContainer/CenterContainer/SaveTrackingOptionButton"

var bp_option = preload("res://UI/Components/TrackingOption.tscn")
var tracking_data
var ready = false
var title = "Heading not set!"
var selected_option setget set_option
var aspect
var options = {}
	
func set_tracking_data(new_tracking_data, new_aspect): 
	tracking_data = new_tracking_data
	aspect = new_aspect
	Logger.print("Aspect got data!", self)
	if ready: _show_data()
	
func set_title(new_title): 
	title = new_title
	if ready: heading.set_heading(title)
	
func _ready(): 
	ready = true
	_show_data()
	heading.set_heading(title)
	select_button.disabled = selected_option == null
	connect("emit_option", AspectTrackingService, "commit_tracking_level")
	#get saved option


func _get_current_tracking_level():
	if aspect == null: return
	var current_level = AspectTrackingService.get_current_tracking_level(aspect)
	if current_level == null: return
	print("level %s" % str(current_level.level))
	if options.has(current_level.level):
		selected_option = options.get(current_level.level)
		selected_option.preselect()
	
func _show_data(): 
	if tracking_data == null: 
		Logger.print("Aspect missing data!", self)
		return
	question.set_text(tracking_data.question)
	#clear previous options if any
	for child in options_holder.get_children(): 
		options_holder.remove_child(child)
	#show options
	if tracking_data.options == null: 
		return
	for option_data in tracking_data.options: 
		var new_option_instance = bp_option.instance()
		new_option_instance.set_checkbox_controller_path(options_holder.get_path())
		new_option_instance.set_tracking_option_data(option_data)
		new_option_instance.connect("selected", self, "set_option")
		options[option_data.level] = new_option_instance
		options_holder.add_child(new_option_instance)
	_get_current_tracking_level()
func set_option(option):
	selected_option = option
	select_button.text = "Speichern"
	print(option)
	select_button.disabled = false


func _on_SaveTrackingOptionButton_pressed():
	select_button.disabled = true
	select_button.text = "Gespeichert!"
	emit_signal("emit_option", selected_option.option_data, aspect)
