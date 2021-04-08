tool
extends PanelContainer

signal selected(answer)
signal unselected(answer)

export (StyleBox) var default = preload("res://UI/Components/infobits/AnswerButtonStyleBox_default.tres") setget set_style_default
export (StyleBox) var selected = preload("res://UI/Components/infobits/AnswerButtonStyleBox_default.tres") setget set_style_selected
export (StyleBox) var selected_correct = preload("res://UI/Components/infobits/AnswerButtonStyleBox_default.tres") setget set_style_selected_correct
export (StyleBox) var correct = preload("res://UI/Components/infobits/AnswerButtonStyleBox_default.tres") setget set_style_correct
export (StyleBox) var wrong = preload("res://UI/Components/infobits/AnswerButtonStyleBox_default.tres") setget set_style_wrong

export (Texture) var icon_default = preload("res://Assets/Icons/answer_checkbox_default.png") setget set_icon_style_default
export (Texture) var icon_selected = preload("res://Assets/Icons/answer_checkbox_selected.png") setget set_icon_style_selected
export (Texture) var icon_selected_correct = preload("res://Assets/Icons/answer_checkbox_selected_correct.png") setget set_icon_style_selected_correct
export (Texture) var icon_correct = preload("res://Assets/Icons/answer_checkbox_correct.png") setget set_icon_style_correct
export (Texture) var icon_wrong= preload("res://Assets/Icons/answer_checkbox_wrong.png")  setget set_icon_style_wrong

enum AnswerState {DEFAULT, SELECTED, SELECTED_CORRECT, CORRECT, WRONG}
export(AnswerState) var state setget set_state

export (String) var answer_text setget set_label_text
export var is_correct = false   
export var is_checked = false

onready var label = $MarginContainer/Label
onready var checkbox = $MarginContainer/Control2/CheckBox

var can_fire = true
var answer setget set_answer
func _ready():
	_set_style()
	$MarginContainer/Label.text = answer_text

func set_label_text(new_text):
	answer_text = new_text
	if (label ==  null): return
	label.text = answer_text if (answer_text != null) else label.text

func set_answer(new_answer): 
	answer = new_answer
	is_correct = new_answer.correct
	set_label_text(new_answer.value)

func set_style_default(new_style): 
	default = new_style
	_set_style()

func set_style_selected(new_style): 	
	selected = new_style
	_set_style()

func set_style_selected_correct(new_style): 
	selected_correct = new_style
	_set_style()

func set_style_correct(new_style): 
	correct = new_style
	_set_style()

func set_style_wrong(new_style): 
	wrong = new_style
	_set_style()

func set_icon_style_default(new_style): 
	icon_default = new_style
	_set_style()

func set_icon_style_selected(new_style): 
	icon_selected = new_style
	_set_style()

func set_icon_style_selected_correct(new_style): 
	icon_selected_correct = new_style
	_set_style()

func set_icon_style_correct(new_style): 
	icon_correct = new_style
	_set_style()

func set_icon_style_wrong(new_style): 
	icon_wrong = new_style
	_set_style()

func set_state(new_state):
	state = new_state 
	_set_style()

func _set_style():
	if (checkbox == null): return
	match(state): 
		AnswerState.DEFAULT:
			set("custom_styles/panel", default)
			checkbox.texture = icon_default
			if(label): label.set("custom_colors/font_color", Color("#646363"))
		AnswerState.SELECTED:
			set("custom_styles/panel", selected)
			checkbox.texture = icon_selected
			if(label): label.set("custom_colors/font_color", Color("#646363"))
		AnswerState.SELECTED_CORRECT:
			set("custom_styles/panel", selected_correct)
			checkbox.texture = icon_selected_correct
			if(label): label.set("custom_colors/font_color", Color("#ffffff"))
		AnswerState.CORRECT:
			set("custom_styles/panel", correct)
			checkbox.texture = icon_correct
			if(label): label.set("custom_colors/font_color", Color("#ffffff"))
		AnswerState.WRONG:
			set("custom_styles/panel", wrong)
			checkbox.texture = icon_wrong
			if(label): label.set("custom_colors/font_color", Color("#ffffff"))

func check_result():
	return (state == AnswerState.SELECTED) != is_correct

func _on_MarginContainer_gui_input(event):
	if(can_fire && event is InputEventMouseButton):
		#print(event.as_text())
#		can_fire = false
		if event.pressed:
				if(state == AnswerState.DEFAULT):
					emit_signal("selected", self)
					#print("selected ", answer_text)
					set_state(AnswerState.SELECTED)
				elif(state == AnswerState.SELECTED): 
					emit_signal("unselected", self)
					#print("unselected ", answer_text)
					set_state(AnswerState.DEFAULT)
#		yield(get_tree().create_timer(1.0), "timeout")
#		can_fire = true

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
