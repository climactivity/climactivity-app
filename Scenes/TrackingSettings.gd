extends VBoxContainer

signal emit_option(option, aspect)

onready var http_request = $HTTPRequest
onready var question = $"MarginContainer2/kiko_avatar - placeholder"

onready var options_holder = $"Options"
onready var select_button = $"MarginContainer/CenterContainer/SaveTrackingOptionButton"
onready var select_button_label = $"MarginContainer/CenterContainer/SaveTrackingOptionButton/Label"
var bp_option = preload("res://UI/Components/TrackingOption.tscn")
var tracking_data
var ready = false
var title = "Heading not set!"
var selected_option setget set_option, get_option
var initial_option
var aspect
var options = {}

func get_option(): 
	return selected_option
	
func set_tracking_data(new_tracking_data, new_aspect): 
	tracking_data = new_tracking_data
	aspect = new_aspect
	Logger.print("Aspect got data!", self)

	if ready: _show_data()
	
func set_title(new_title): 
	title = new_title
#	if ready: heading.set_heading(title)
	
func _ready(): 
	ready = true
	select_button.disabled = true
	_show_data()
#	heading.set_heading(title)

	connect("emit_option", AspectTrackingService, "commit_tracking_level")
	#get saved option


func _get_current_tracking_level():
	if aspect == null: return
	var current_level = AspectTrackingService.get_current_tracking_level(aspect)
	if current_level == null: return
	print("level %s" % str(current_level.level))
	if options.has(current_level.level):
		selected_option = options.get(current_level.level)
		initial_option = selected_option
		select_button.disabled = selected_option == null
		select_button_label.text = tr("tracking_options_button_confirm")
		selected_option.preselect()
		selected_option = initial_option
		select_button.disabled = !AspectTrackingService.has_seedling_available(aspect)
	else:
		select_button_label.text = tr("tracking_options_button_save")
		select_button.disabled = true
		
func _show_data(): 
	if tracking_data == null: 
		Logger.print("Aspect missing data!", self)
		return
	question.set_text(tracking_data.question)
	#clear previous options if any
	Util.clear(options_holder)
	#show options
	if tracking_data.options == null: 
		return
	for option_data in tracking_data.options: 
		if !option_data.has("waterFactor") or option_data.waterFactor == "0": 
			continue
		var new_option_instance = bp_option.instance()
		new_option_instance.set_checkbox_controller(options_holder)
		new_option_instance.set_tracking_option_data(option_data)
		new_option_instance.connect("selected", self, "set_option")
		options[option_data.level] = new_option_instance
		options_holder.add_child(new_option_instance)
	_get_current_tracking_level()

func set_option(option):
	if option == selected_option: 
		selected_option = initial_option
	else:
		selected_option = option
	
	if initial_option == null or selected_option != initial_option : 
		select_button_label.text = tr("tracking_options_button_save")
		select_button.disabled = false
	else:
		tr("tracking_options_button_confirm")
		select_button.disabled = !AspectTrackingService.has_seedling_available(aspect)



func _on_SaveTrackingOptionButton_pressed():
	select_button.disabled = true
	select_button_label.text = tr("tracking_options_button_saved")
	emit_signal("emit_option", selected_option.option_data if selected_option != null else null, aspect)
	if initial_option != null and selected_option == initial_option:
		GameManager.scene_manager.push_scene("res://Scenes/EntityShopScene.tscn", {"aspect": aspect})

