extends Control

var question setget set_question

signal ready_to_check
signal cannot_check
signal on_next_question

var question_text
var question_mode = "radio_buttons" 
var answers = []
var num_correct_answers = 0
var selected_answers = []
#onready var answer_text = $"SpeechBubbleHolder/MarginContainer/DialogLine"
var answer_button_factory = preload("res://UI/Components/infobits/AnswerOption.tscn")
onready var answer_button_holder = $VBoxContainer2/VBoxContainer
enum AnswerState {DEFAULT, SELECTED, SELECTED_CORRECT, CORRECT, WRONG} # kill it with fire

export (NodePath) onready var question_box

func _ready():
	question_box = get_node(question_box)
	question_box.set_text( question_text if question_text != null else "null" )
	for answer_button in answers:
		answer_button_holder.add_child(answer_button)
		answer_button.connect("selected", self, "_on_answer_selected")
		answer_button.connect("unselected", self, "_on_answer_unselected")

func play_enter(): 
	question_box.play_enter()
	$"VBoxContainer2/VBoxContainer/Stagger".play_enter()
	$AnimationPlayer.play("Enter")
	
func set_question(new_question): 
	question = new_question
	question_text = question.question
	question_mode = question.question_mode if question.has("question_mode") else "radio_buttons" 
	for answer in question.answers:
		var answer_button = answer_button_factory.instance()
		answers.append(answer_button)
		answer_button.set_answer_data(answer)
		if answer.has("correct") and answer["correct"]:
			print("ping")
			num_correct_answers += 1
	match num_correct_answers:
		0: 
			Logger.error("No correct answers in question: %s" % question.question, self )
		1: 
			$"VBoxContainer2/Label".text = tr("hint_select_exactly_one")
		_:
			$"VBoxContainer2/Label".text = tr("hint_select_at_least_one")
func _on_answer_selected(answer): 
	if(question_mode == "radio_buttons"): 
		for answer_button in selected_answers:
			answer_button.set_state(AnswerState.DEFAULT)
			selected_answers.clear()
		answer.set_state(AnswerState.SELECTED)
		selected_answers.push_back(answer)
		_can_check()

func clear_selected():
	if(question_mode == "radio_buttons"): 
		selected_answers.clear()
		for answer in answers:
			answer.unlock()
			answer.reset()

func _on_answer_unselected(answer):
	var index = selected_answers.find(answer)
	if (index != -1): selected_answers.remove(index)
	_can_check()
func check_result():
	for answer_button in answers:
		answer_button.lock() 
	return selected_answers
	
func get_result(): 
	if(question_mode == "radio_buttons"): 
		if selected_answers.empty(): return 0.0
		var correct_answers = []
		for answer in selected_answers: 
			if answer.is_correct:
				correct_answers.push_back(answer)
		return float(correct_answers.size()) / float(selected_answers.size())
	else:
		return 0.0	
	
	
func _can_check():
	if(selected_answers.size() > 0): 
		emit_signal("ready_to_check")
	else: 
		emit_signal("cannot_check")
