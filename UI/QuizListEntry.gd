extends HBoxContainer

var quiz setget set_quiz 

func set_quiz(new_quiz):
	quiz = new_quiz 
	$Label.text = quiz.name
	

func _on_Button_pressed():
	print("loading ", quiz.name)
