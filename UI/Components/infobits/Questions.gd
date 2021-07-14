extends Control

signal anim_finished
signal end_reached
signal selected_answer
signal can_check
signal cannot_check
signal has_checked

signal question_state(position, state)

var questions_data 
var questions = []
var selected_answers = []
var correct = 0 

var current_question = -1

var question_box_factory = preload("res://UI/Components/infobits/QuestionBox.tscn")
onready var current = $MarginContainer/Current
onready var last = $MarginContainer2/Last
onready var anim_player = $AnimationPlayer

func on_data(new_data):
	questions_data = new_data
	for question_box in questions:
		question_box.free()
	questions.clear()
	for question in questions_data: 
		# hack to skip empty questions
		if question.question == "":
			Logger.error("Malformed question!", self)
			continue
		var question_box = question_box_factory.instance()
		questions.append(question_box)
		question_box.set_question(question)
		question_box.connect("ready_to_check", self, "_can_check")
		question_box.connect("cannot_check", self, "_cannot_check")
		

func next():
	if current_question < questions.size() - 1:
		current_question = current_question + 1
		if questions[current_question].get_result() == 0.0:
			Logger.print("Set active question index: " + str(current_question), self)
			_update_question("forward")
			emit_signal("question_state" , current_question, ProgressBlip.BlipMode.QUIZ)
			return
	var next_index = get_next_incorrect()
	if next_index != -1:
		current_question = next_index
		Logger.print("Set active question index: " + str(current_question), self)
		_update_question("forward")
	else:
		emit_signal("end_reached")


func get_next_incorrect(): 
	var results = []
	for question_box in questions:
		var result = question_box.get_result()
		results.push_back(result)
	if results.empty():
		return -1
	var next_index = results.find(0.0,0)
	return next_index
	
func _update_question(anim_to_play):
	for child in last.get_children():
		last.remove_child(child)
	for child in current.get_children():
		current.remove_child(child)
		last.add_child(child)
	var next_question_parent = questions[current_question].get_parent()
	if next_question_parent:
		next_question_parent.remove_child(questions[current_question])
	current.add_child(questions[current_question])
	questions[current_question].clear_selected()
	questions[current_question].play_enter()
	anim_player.play(anim_to_play)

func _can_check(): 
	emit_signal("can_check")

func _cannot_check(): 
	emit_signal("cannot_check") 
	
func check_answer():
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
