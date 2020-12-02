extends Panel

onready var req = $VBoxContainer/HTTPRequest

var request_str = "%s://%s/infobyte/%s"

func receive_navigation(quiz_data):
	print("[QuizScene]" ,"recieve nav: ", quiz_data)
	req.request(request_str % "https" % "localhost" % quiz_data.id )


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
