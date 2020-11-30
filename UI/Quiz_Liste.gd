extends Control

var loading = true

onready var list_view = $VBoxContainer/ScrollContainer/ListView

func _ready():
	$GetAvailableQuizzes.request("http://localhost:3000/infobyte")

func _on_BackButton_pressed():
	GameManager.scene_manager.pop_scene()


func _on_GetAvailableQuizzes_request_completed(result, response_code, headers, body):
	loading = false
	var json = JSON.parse(body.get_string_from_utf8())
	_on_quiz_list(json.result)

func _on_quiz_list(quiz_list):
	for quiz in quiz_list:
		print(quiz.name)
		if(quiz.name):
			list_view.add_item(quiz)
	pass
