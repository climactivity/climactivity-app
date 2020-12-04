extends Panel

signal next_infobit
signal next_question

onready var req = $VBoxContainer/HTTPRequest
onready var header = $VBoxContainer/Header
onready var kiko_dialog = $"VBoxContainer/Content/VSplitContainer/ContentHolder/FrontMatter/kiko_avatar - placeholder/SpeechBubbleHolder/DialogLine"
onready var loading_anim = $"VBoxContainer/Content/VSplitContainer/ContentHolder/Loading"
onready var continue_button = $"VBoxContainer/Content/VSplitContainer/Footer/ContinueButton"
onready var infobit_holder = $"VBoxContainer/Content/VSplitContainer/ContentHolder/Infobits"
onready var anim_player = $AnimationPlayer
var request_str = "%s://%s/infobyte/%s"
var has_data = false
var has_error = false
var quiz_data
var error 
var state = InfoByteState.LOADING

enum InfoByteState {
	LOADING,
	FRONT,
	INFO,
	QUIZ_INTRO,
	QUIZ,
	QUIZ_COMPLETE,
	ERROR
}

func _ready():
	connect("next_infobit", infobit_holder, "next")
	infobit_holder.connect("finished", self, "_last_infobit")
	loading_anim.connect("finished_loading", self, "_finished_loading")
func receive_navigation(quiz_data):
	#req.request(request_str % ["https", "localhost", quiz_data.quiz._id] )
	header.set_screen_label(quiz_data.quiz.name)
	Api.getQuizData(req, quiz_data.quiz._id)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		has_error = true
		error = json.error
		state = InfoByteState.ERROR
		continue_button.set_disabled(true)
		Logger.error("Server error: "+ json.error, self)
	else:
		has_data = true
		quiz_data = json.result
		state = InfoByteState.FRONT
		continue_button.set_disabled(false)
		Logger.print("Loaded " + quiz_data.name, self)
		_on_quiz_data(quiz_data)

func _on_quiz_data(quiz_data):
	#print(quiz_data)
	#update header
	header.set_screen_label(quiz_data.name)
	kiko_dialog.text = quiz_data.frontmatter
	loading_anim.loading_finished()
	infobit_holder.set_infobits_data(quiz_data.infobits)

func _finished_loading(): 
	anim_player.play("show_frontmatter")

func _show_infobits():
	state = InfoByteState.INFO
	anim_player.play("show_infobit_holder")
	print("show_info")

func _next_infobit(): 
	emit_signal("next_infobit")

func _show_quiz(): 
	state = InfoByteState.QUIZ

func _next_question():
	emit_signal("next_question")
	
func _last_infobit():
	print("last infobit reached")
	
func _on_ContinueButton_pressed():
	match(state):
		InfoByteState.LOADING:
			pass
		InfoByteState.FRONT:
			_show_infobits()
		InfoByteState.INFO:
			_next_infobit()
		InfoByteState.QUIZ_INTRO:
			_show_quiz()
		InfoByteState.QUIZ:
			_next_question()
		InfoByteState.QUIZ_COMPLETE:
			pass
		InfoByteState.ERROR:
			pass

