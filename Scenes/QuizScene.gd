extends Panel

signal next_infobit
signal next_question
signal prev_infobit
signal prev_question
signal check_answer

onready var req = $VBoxContainer/HTTPRequest
onready var header = $HeaderContainer/Header
onready var kiko_dialog = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/FrontMatter/kiko_avatar - placeholder"
onready var loading_anim = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/Loading"
onready var continue_button = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/Footer/ContinueButton"
onready var back_button = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/Footer/BackButton"
onready var infobit_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/Infobits"
onready var anim_player = $AnimationPlayer
onready var questions_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/Quiz/Questions"
var has_data = false
var has_error = false
var quiz_data
var error 
var state = InfoByteState.LOADING

var reshow = false
var wait_check = false 
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
	connect("prev_infobit", infobit_holder, "prev")
	
	infobit_holder.connect("finished", self, "_last_infobit")
	infobit_holder.connect("anim_finished", self, "_content_anim_finished")
	infobit_holder.connect("go_back", self, "_reshow_frontmatter")
	
	connect("next_question", questions_holder, "next")
	connect("check_answer", questions_holder, "check_answer")
	questions_holder.connect("end_reached", self, "_last_question")
	questions_holder.connect( "can_check", self, "_can_check")
	questions_holder.connect( "has_checked" ,self, "_has_checked")
	loading_anim.connect("finished_loading", self, "_finished_loading")
	
	header.connect("go_back", self, "_on_back_button")
	
func receive_navigation(quiz_data):
	#req.request(request_str % ["https", "localhost", quiz_data.quiz._id] )
	header.set_screen_label(quiz_data.quiz.name)
	_on_quiz_data(quiz_data.quiz)
	#Api.getQuizData(req, quiz_data.quiz._id)


#func _on_HTTPRequest_request_completed(result, response_code, headers, body):
#	var json = JSON.parse(body.get_string_from_utf8())
#	if(json.error): 
#		has_error = true
#		error = json.error
#		state = InfoByteState.ERROR
#		continue_button.set_disabled(true)
#		Logger.error("Server error: "+ json.error, self)
#	else:
#		has_data = true
#		quiz_data = json.result
#		state = InfoByteState.FRONT
#		continue_button.set_disabled(false)
#		Logger.print("Loaded " + quiz_data.name, self)
#		_on_quiz_data(quiz_data)

func _on_quiz_data(quiz_data):
	header.set_screen_label(quiz_data.name)
	kiko_dialog.set_text(quiz_data.frontmatter)
	loading_anim.loading_finished()
	infobit_holder.set_infobits_data(quiz_data.info_bits)
	questions_holder.on_data(quiz_data.questions)

func _finished_loading(): 
	anim_player.play("show_frontmatter")

func _show_infobits():
	state = InfoByteState.INFO
	anim_player.play("show_infobit_holder")

func _next_infobit(): 
	if reshow:
		reshow = false
		return
	emit_signal("next_infobit") 
	back_button.set_disabled(false)

func _prev_infobit(): 
	emit_signal("prev_infobit")
	
func _last_infobit():
	Logger.print("Last infobit reached " + quiz_data.name, self)
	state = InfoByteState.QUIZ_INTRO
	anim_player.play("show_quiz_intro")
	
func _show_quiz(): 
	state = InfoByteState.QUIZ
	back_button.set_disabled(true)
	back_button.visible = false
	anim_player.play("show_quiz")

func _next_question():
	if(wait_check):
		emit_signal("check_answer")
	else:
		emit_signal("next_question")
		_wait_check()

func _prev_question():
	emit_signal("prev_question")

func _wait_check():
	continue_button.set_disabled(true)
	continue_button.set_text("Wählen")
	wait_check = true
	
func _can_check():
	continue_button.set_disabled(false)
	
func _has_checked(): 
	wait_check = false
	continue_button.set_text("Weiter")

func _last_question(): 
	Logger.print("Completed " + quiz_data.name, self)
	var quiz_result = questions_holder.get_quiz_result()
	print(quiz_result)
	var quiz_end_comment = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VSplitContainer/ContentHolder/QuizEnd/kiko_avatar - placeholder"
	var quiz_end_result_text = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VSplitContainer/ContentHolder/QuizEnd/Label"
	var quiz_end_collect_button = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VSplitContainer/ContentHolder/QuizEnd/CollectRewardButton"
	quiz_end_result_text.text = quiz_result.result_string
	anim_player.play("show_quiz_result")
	state = InfoByteState.QUIZ_COMPLETE
	continue_button.set_text("Zur Auswahl")
	continue_button.set_disabled(false)
	
func _content_anim_finished():
	pass
	
func _reshow_frontmatter(): 
	state = InfoByteState.FRONT
	anim_player.play("RESET")
	anim_player.call_deferred("play", "show_frontmatter")
	infobit_holder.set_infobits_data(quiz_data.infobits)
	
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
			GameManager.scene_manager.pop_scene()
		InfoByteState.ERROR:
			pass

func _nav_back():
	GameManager.scene_manager.pop_scene()
	
func _on_back_button():
	match(state):
		InfoByteState.LOADING:
			GameManager.scene_manager.pop_scene()
		InfoByteState.FRONT:
			GameManager.scene_manager.pop_scene()
		InfoByteState.INFO:
			_prev_infobit()
		InfoByteState.QUIZ_INTRO:
			_show_infobits()
			reshow = true
		InfoByteState.QUIZ:
			_prev_question()
		InfoByteState.QUIZ_COMPLETE:
			pass
		InfoByteState.ERROR:
			pass

# passed of to extra function so the header back button can hook in even if the local back button is disabled
func _on_BackButton_pressed():
	_on_back_button()
