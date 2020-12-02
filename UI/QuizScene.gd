extends Panel

onready var req = $VBoxContainer/HTTPRequest
onready var header = $VBoxContainer/Header
onready var kiko_dialog = $"VBoxContainer/Content/VSplitContainer/ContentHolder/kiko_avatar - placeholder/SpeechBubbleHolder/DialogLine"

var request_str = "%s://%s/infobyte/%s"
var has_data = false
var has_error = false
var quiz_data

func receive_navigation(quiz_data):
	#req.request(request_str % ["https", "localhost", quiz_data.quiz._id] )
	header.set_screen_label(quiz_data.quiz.name)
	Api.getQuizData(req, quiz_data.quiz._id)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		Logger.error("Server error: "+ json.error, self)
	else:
		has_data = true
		quiz_data = json.result
		Logger.print("Loaded " + quiz_data.name, self)
		_on_quiz_data(quiz_data)

func _on_quiz_data(quiz_data):
	
	#print(quiz_data)
	#update header
	header.set_screen_label(quiz_data.name)
	kiko_dialog.text = quiz_data.frontmatter
