extends Control

signal selected(option)

var option_data setget set_tracking_option_data
export (NodePath) var checkbox_controller_path setget set_checkbox_controller_path, get_checkbox_controller_path
var checkox_controller
onready var label = $MarginContainer/MarginContainer2/VBoxContainer/Label
onready var reward_label = $MarginContainer/MarginContainer2/VBoxContainer/Reward
onready var select_button = $"MarginContainer/HBoxContainer/SelectButton"
var preselected = false
func _ready(): 
	if option_data == null: return
	_update_fields()
	checkox_controller = get_node(checkbox_controller_path)
	if checkox_controller != null:
		checkox_controller.register(select_button)
		select_button.connect("pressed", self, "selected")
	if select_button != null and preselected: select_button._check()

	
func set_tracking_option_data(new_option_data): 
	option_data = new_option_data
	if label != null && reward_label != null:
		_update_fields()
	
func _update_fields(): 
	label.text = option_data.option
	reward_label.set_reward(option_data.reward) 
	
func set_checkbox_controller_path(new_controller_path):
	checkbox_controller_path = new_controller_path 
	checkox_controller = get_node_or_null(checkbox_controller_path)
	if checkox_controller != null: checkox_controller.register(select_button)
	
func get_checkbox_controller_path(): 
	return checkbox_controller_path

func selected():
	emit_signal("selected", self)	

func preselect(): 
	preselected = true
	if select_button != null: select_button._check()
