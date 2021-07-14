extends PanelContainer

signal selected(option)
signal deselected(option)

export var panel_style = preload("res://UI/Components/M_TrackingOption.tres")
var selected = false
#var option_data setget set_tracking_option_data
var answer_data setget set_answer_data

export (NodePath) var checkbox_controller_path setget set_checkbox_controller_path, get_checkbox_controller_path
var checkox_controller
onready var label = $MarginContainer/Panel/MarginContainer/MarginContainer2/VBoxContainer/Label
onready var select_button = $MarginContainer/Panel/HBoxContainer/SelectButton
onready var panel = $MarginContainer/Panel/Panel

var preselected = false

enum AnswerState {DEFAULT, SELECTED, SELECTED_CORRECT, CORRECT, WRONG}
export(AnswerState) var state setget set_state

export var is_correct = false   
export var is_checked = false

#onready var label = $MarginContainer/Label
#onready var checkbox = $MarginContainer/Control2/CheckBox

func _ready(): 
	if answer_data == null: return
	update()
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
	
func set_answer_data(new_answer_data): 
	answer_data = new_answer_data
	is_correct = new_answer_data.correct
	if label != null:
		update()

func set_state(_state):
	state = _state
	update()

func update(): 	
#	if (label == null): return
	label.text = answer_data.value
	match(state): 
		AnswerState.DEFAULT:
#			set("custom_styles/panel", default)
#			checkbox.texture = icon_default
			modulate = Color("#ffffff")
			$AnimationPlayer.play("RESET")
#			if(label): label.set("custom_colors/font_color", Color("#696968"))
		AnswerState.SELECTED:
#			set("custom_styles/panel", selected)
#			checkbox.texture = icon_selected
			modulate = Color("#d4d4d4")
			$AnimationPlayer.play("Select")
#			if(label): label.set("custom_colors/font_color", Color("#ffffff"))
		AnswerState.SELECTED_CORRECT:
#			set("custom_styles/panel", selected_correct)
#			checkbox.texture = icon_selected_correct
			modulate = Color("#00ff00")
#			if(label): label.set("custom_colors/font_color", Color("#ffffff"))
		AnswerState.CORRECT:
#			set("custom_styles/panel", correct)
#			checkbox.texture = icon_correct
			modulate = Color("#aaffaa")
#			if(label): label.set("custom_colors/font_color", Color("#ffffff"))
		AnswerState.WRONG:
#			set("custom_styles/panel", wrong)
#			checkbox.texture = icon_wrong
			modulate = Color("#ff0000")
#			if(label): label.set("custom_colors/font_color", Color("#ffffff"))
	
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
#	if can_fire:
#		can_fire = false
	if(state == AnswerState.DEFAULT):
		emit_signal("selected", self)
		#print("selected ", answer_text)
		set_state(AnswerState.SELECTED)
	elif(state == AnswerState.SELECTED): 
		emit_signal("unselected", self)
		#print("unselected ", answer_text)
		set_state(AnswerState.DEFAULT)

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

var can_fire = true
func lock(): 
	can_fire = false
	if state == AnswerState.SELECTED:
		if is_correct:
			set_state(AnswerState.SELECTED_CORRECT)
		else:
			set_state(AnswerState.WRONG)
	else:
		if is_correct:
			set_state(AnswerState.CORRECT)

func unlock():
	can_fire = true
	set_state(AnswerState.DEFAULT)
