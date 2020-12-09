extends Control

signal anim_finished
signal end_reached
signal selected_answer
signal can_check
signal has_checked
var questions_data 
var questions = []
var selected_answers = []
var questions_count = 0
var correct = 0 

var current_question = -1

var question_box_factory = preload("res://UI/Components/infobits/QuestionBox.tscn")
onready var current = $MarginContainer/Current
onready var last = $MarginContainer2/Last
onready var anim_player = $AnimationPlayer

func on_data(new_data):
	questions_data = new_data
	for question in questions_data: 
		var question_box = question_box_factory.instance()
		questions.append(question_box)
		question_box.set_question(question)
		question_box.connect("ready_to_check", self, "_can_check")

func next():
	if current_question < questions.size() - 1:
		current_question = current_question + 1
		Logger.print("Set active question index: " + str(current_question), self)
		_update_question("forward")
	else:
		emit_signal("end_reached")

func _update_question(anim_to_play):
	for child in last.get_children():
		last.remove_child(child)
	for child in current.get_children():
		last.add_child(child)
		current.remove_child(child)
	current.add_child(questions[current_question])
	anim_player.play(anim_to_play)

func _can_check(): 
	print("can_check")
	emit_signal("can_check")

func check_answer():
	print("has_checked")
	var question_result = questions[current_question].check_result()
	selected_answers.push_back(question_result)
	emit_signal("has_checked")

func get_quiz_result(): 
	var results = []
	for question_box in questions:
		var result = question_box.get_result()
		results.push_back(result)
	if results.empty():
		return {
			"result_string": "0 Richtig",
			"score_percent": 0.0
		}
	var result_string 
	var score_percent = 0.0
	var score_total = 0.0
	for result in results:
		score_total += result
	score_percent = score_total / results.size()
	return {
		"result_string": "%.2f/%d Richtig" % [score_total, results.size()],
		"score_percent": score_percent
	}
