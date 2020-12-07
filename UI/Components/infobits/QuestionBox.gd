extends Control

var question setget set_question

var question_text
var answers = []
onready var answer_text = $"SpeechBubbleHolder/MarginContainer/DialogLine"
var answer_button_factory = preload("res://UI/Components/infobits/AnswerButton.tscn")
onready var answer_button_holder = $VBoxContainer

func _ready():
	answer_text.text = question_text 
	for answer_button in answers:
		answer_button_holder.add_child(answer_button)

func set_question(new_question): 
	question = new_question
	question_text = question.question

	for answer in question.answers:
		print(answer)
		var answer_button = answer_button_factory.instance()
		answer_button.is_correct = answer.correct
		answer_button.set_label_text(answer.value)
		answers.append(answer_button)
