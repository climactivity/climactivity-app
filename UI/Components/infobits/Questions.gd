extends Control

signal anim_finished
signal end_reached
signal selected_answer

var questions_data 
var questions = []
var questions_count = 0
var correct = 0 

var current_question = 0 

func on_data(new_data):
	print(new_data)
	questions_data = new_data
	for question in questions_data: 
		questions.append(question)

func next():
	pass

func prev():
	pass
