extends Panel

onready var req = $VBoxContainer/HTTPRequest

var request_str = "%s://%s/infobyte/%s"
var has_data = false
var has_error = false
var quiz_data

func receive_navigation(quiz_data):
	#req.request(request_str % ["https", "localhost", quiz_data.quiz._id] )
	Api.getQuizData(req, quiz_data.quiz._id)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):

	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		Logger.error("Server error: "+ json.error, self)
	else:
		has_data = true
		quiz_data = json.result
		Logger.print("Loaded " + quiz_data.name, self)
