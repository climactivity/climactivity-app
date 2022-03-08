extends Control

signal selected(option)
signal deselected(option)
export var badge = preload("res://UI/Components/ImportanceBadge.tscn")
export var panel_style = preload("res://UI/Components/M_TrackingOption2.tres")
var selected = false
var option_data setget set_tracking_option_data
export (NodePath) var checkbox_controller_path setget set_checkbox_controller_path, get_checkbox_controller_path
var checkox_controller
onready var label = $MarginContainer/Panel/MarginContainer/MarginContainer2/VBoxContainer/Label
onready var reward_label = $MarginContainer/Panel/MarginContainer/MarginContainer2/VBoxContainer/Reward
onready var select_button = $MarginContainer/Panel/HBoxContainer/SelectButton
onready var panel = $MarginContainer/Panel/Panel
onready var badge_inst = $"MarginContainer/Panel/BadgeAttach/ImportanceBadge"
var preselected = false
func _ready(): 

	if option_data == null: return
	_update_fields()
#	checkox_controller = get_node(checkbox_controller_path)
	if checkox_controller != null:
		checkox_controller.register(select_button)
		select_button.connect("checked", self, "selected")
		select_button.connect("unchecked", self, "deselected")
#		select_button.connect("pressed", self, "selected")
	if select_button != null and preselected: select_button._check()
	#duplicate panel style so other panels don't get messed up
	var new_style = panel_style.duplicate()
	panel.set('custom_styles/panel', new_style)
	selected = preselected

func set_tracking_option_data(new_option_data): 
	option_data = new_option_data
	if label != null && reward_label != null:
		_update_fields()
	
func _update_fields(): 
	label.text = option_data.option
	var reward_to_display = option_data.reward
	if option_data.has("waterFactor"):
		reward_to_display.water = option_data.waterFactor
	reward_label.set_reward(reward_to_display) 
	badge_inst.level = option_data.level + 1
	
func set_checkbox_controller(controller):
	checkox_controller = controller
#	checkox_controller.register(select_button)
#	select_button.connect("pressed", self, "selected")
	
func set_checkbox_controller_path(new_controller_path):
	checkbox_controller_path = new_controller_path 
	checkox_controller = get_node_or_null(checkbox_controller_path)
	if checkox_controller != null: checkox_controller.register(select_button)
	
func get_checkbox_controller_path(): 
	return checkbox_controller_path

func selected():
#	print("selected: " + self.name + " preselected: " + str(preselected) + " selected: " + str(selected))
	if selected:
		return
	selected = true
	emit_signal("selected", self)
	$AnimationPlayer.play("Select")

func deselected():
#	print("deselected: " + self.name + " preselected: " + str(preselected) + " selected: " + str(selected))
	if !selected: 
		return
	selected = false
	emit_signal("deselected", self)
	$AnimationPlayer.play("Deselect")
	
func preselect(): 
	preselected = true
	if select_button != null: 
		select_button._check()
		$AnimationPlayer.play("Preselected")


func _on_Button_pressed():
	select_button._on_Control_pressed()

func _on_Button_button_down():
	modulate = Color("#afafaf")

func _on_Button_button_up():
	modulate = Color.white

var last_touch_point : Vector2
export var accept_radius = 5.0
func _on_Panel_gui_input(event):
	if event is InputEventScreenDrag: # reject input while scrolling
		_on_Button_button_up()
		return

	if event is InputEventScreenTouch: 
		if event.pressed:
			_on_Button_button_down()
			last_touch_point = event.position
		else: 
			if (event.position - last_touch_point).length() < accept_radius:
				_on_Button_button_up()
				_on_Button_pressed()

func play_enter():
	$Enter.play("Enter")


func _on_SelectButton_unchecked():
	deselected()
