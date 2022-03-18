extends PanelContainer

signal focus(node)

export (Color) var correct_modulate : Color = Color.limegreen
export (Color) var incorrect_modulate : Color = Color.lightcoral
export (Color) var dnf_modulate : Color = Color.gray

onready var own_name_label = $VBoxContainer/HBoxContainer/YouContainer/HBoxContainer/OwnNameLabel
onready var oppnent_name_label = $VBoxContainer/HBoxContainer/OppContainer/HBoxContainer/OpponentLabel

onready var own_state_indicator = $VBoxContainer/HBoxContainer/YouContainer/HBoxContainer/AspectRatioContainer/SelfCorrect
onready var opponent_state_indicator = $VBoxContainer/HBoxContainer/OppContainer/HBoxContainer/AspectRatioContainer/OpponentCorrect

onready var heading_label = $VBoxContainer/Heading/HeadingLabel

func set_state(p_index : int, p_match_state : VSQuizAPI.VSQuizState, p_own_session_id : String, p_opponent_session_id : String, p_opponent_name): 
	var index = p_index
	var question: VSQuizAPI.VSQuestion = p_match_state.questions[index]
	_set_question_details(question, p_index)

	oppnent_name_label.text = p_opponent_name

	var answers = p_match_state.answers[index]
	_set_indicator(own_state_indicator, answers, p_own_session_id)
	_set_indicator(opponent_state_indicator, answers, p_opponent_session_id)

func _set_question_details(p_question: VSQuizAPI.VSQuestion, p_index):
	heading_label.text = "Frage %d" % (p_index + 1)

func _set_indicator(p_indicator, p_answers, p_session_id ):
	if p_answers.has(p_session_id): 
		var answer : VSQuizAPI.VSPlayerAnswer = p_answers[p_session_id]
		if answer.correct:
			p_indicator.modulate = correct_modulate
		else:
			p_indicator.modulate = incorrect_modulate
	else: 
		p_indicator.modulate = dnf_modulate

func play_enter():
	$AnimationPlayer.play("Enter")
	
func show_details():
	emit_signal("focus", self)
	$AnimationPlayer.play("ShowDetails")

func hide_details(): 
	$AnimationPlayer.play_backwards("ShowDetails")

var is_show_details = false

func _on_ShowDetailsButton_pressed():
	is_show_details = !is_show_details
	if is_show_details:
		show_details()
	else:
		hide_details()
