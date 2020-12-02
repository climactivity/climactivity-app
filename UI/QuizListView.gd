extends VBoxContainer

var element = preload("res://UI/Components/QuizListEntry.tscn")

func add_item(quiz): 
	var item = element.instance()
	item.set_quiz(quiz)
	add_child(item)
