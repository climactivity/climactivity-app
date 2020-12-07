tool
extends PanelContainer

export (StyleBox) var default setget set_style_default
export (StyleBox) var selected setget set_style_selected
export (StyleBox) var selected_correct setget set_style_selected_correct
export (StyleBox) var correct setget set_style_correct
export (StyleBox) var wrong setget set_style_wrong

export (Texture) var icon_default setget set_icon_style_default
export (Texture) var icon_selected setget set_icon_style_selected
export (Texture) var icon_selected_correct setget set_icon_style_selected_correct
export (Texture) var icon_correct setget set_icon_style_correct
export (Texture) var icon_wrong setget set_icon_style_wrong

enum AnswerState {DEFAULT, SELECTED, SELECTED_CORRECT, CORRECT, WRONG}
export(AnswerState) var state setget set_state

export (String) var answer_text setget set_label_text
export var is_correct = false   
export var is_checked = false

onready var label = $MarginContainer/Control2/Label
onready var checkbox = $MarginContainer/Control2/CheckBox

func _ready():
	_set_style()
	set_label_text(answer_text)

func set_label_text(new_text):
	answer_text = new_text
	label.text = answer_text if (answer_text != null) else label.text

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
	match(state): 
		AnswerState.DEFAULT:
			set("custom_styles/panel", default)
			checkbox.texture = icon_default
		AnswerState.SELECTED:
			set("custom_styles/panel", selected)
			checkbox.texture = icon_selected
		AnswerState.SELECTED_CORRECT:
			set("custom_styles/panel", selected_correct)
			checkbox.texture = icon_selected_correct
		AnswerState.CORRECT:
			set("custom_styles/panel", correct)
			checkbox.texture = icon_correct
		AnswerState.WRONG:
			set("custom_styles/panel", wrong)
			checkbox.texture = icon_wrong
			
func _on_PanelContainer_gui_input(event):
	pass # Replace with function body.
