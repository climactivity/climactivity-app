extends Control

signal anim_finished
signal end_reached
signal selected_answer

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


func next():
	if current_question < questions.size() - 1:
		current_question = current_question + 1
	Logger.print("Set active question index: " + str(current_question), self)
	_update_question("forward")

func _update_question(anim_to_play):
	for child in last.get_children():
		last.remove_child(child)
	for child in current.get_children():
		last.add_child(child)
		current.remove_child(child)
	current.add_child(questions[current_question])
	anim_player.play(anim_to_play)
