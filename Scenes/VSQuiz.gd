extends SceneBase

var matchData : NakamaRTAPI.Match 
var socket : NakamaSocket

var own_presence : NakamaRTAPI.UserPresence

signal current_question(question_idx, time_left, match_state)

var match_state : VSQuizState
var last_match_state_state = false
var is_ready = false 
onready var ready_button = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/ReadyButton

onready var own_name_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/YouContainer/HBoxContainer/OwnNameLabel

onready var opponent_name_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/OppContainer/HBoxContainer/OpponentLabel

onready var self_ready = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/YouContainer/HBoxContainer/AspectRatioContainer/SelfReady

onready var oppnent_ready = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/OppContainer/HBoxContainer/AspectRatioContainer/OpponentReady

onready var timer = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Timer

onready var category_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/PanelContainer/CatergoryLabel

onready var animation_player = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/AnimationPlayer

onready var question_box = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Questions/VBoxContainer/QuestionBox

onready var question_timer = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Questions/VBoxContainer/Timer

onready var question_timer_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Questions/VBoxContainer/Timer/TimerLabel

var unreadyColor = Color.white
var readyColor = Color.greenyellow

func _start_match(_navigation_data):
	
	match_state = VSQuizState.new()
	
	matchData = _navigation_data.joined_match
	own_presence = matchData.self_user

	_update_opponent()
	
	socket = _navigation_data.socket
	socket.connect("received_match_presence", self, "_update_presences")
	socket.connect("received_match_state", self, "_on_match_state")
	connect("current_question", self, "_update_current_question")
func _update_presences(p_presence : NakamaRTAPI.MatchPresenceEvent):
	for p in p_presence.joins:
		matchData.presences.append(p)

	for p in p_presence.leaves:
		matchData.presences.erase(p)
	
	
	_update_opponent()
	
func _update_opponent():
	var others = ""
	for i in range(0,matchData.presences.size()):
		var p : NakamaRTAPI.UserPresence =  matchData.presences[i]
		if p.session_id != own_presence.session_id:
			opponent_name_label.text = p.username

func _on_match_state(p_state: NakamaRTAPI.MatchData):
#	print(p_state)
	var json_result = JSON.parse(p_state.data)

		
	if json_result.error == OK:
		var result = json_result.result
		if result.has("ready") and p_state.presence:
			var affected_presence : NakamaRTAPI.UserPresence = p_state.presence
			if affected_presence.session_id == own_presence.session_id:
				self_ready.modulate = readyColor
			else:
				oppnent_ready.modulate = readyColor
				
		elif p_state.op_code > 2:
			
			match_state = NakamaSerializer.deserialize(self.get_script(), "VSQuizState", result)

			if match_state.show_intro: 
				category_label.text = category_label.text % match_state.num_questions
				animation_player.play("show_intro")
				timer.connect("timeout", self, "count_match_start")
				count_match_start()
			if match_state.show_questions and not last_match_state_state: 
				animation_player.play("GotoQuestions")
				last_match_state_state = true
			if match_state.show_questions: 
				emit_signal("current_question", match_state.current_question, match_state.current_question_time_left ,match_state)
			
var last_idx = -1 
func _update_current_question(idx: int, time_left: float, p_match_state: VSQuizState):
	print(idx, time_left)
	
	question_timer_label.text = "%02d" % floor(time_left)
	question_timer.value = (time_left / p_match_state.time_limit_questions) * 100.0
	
	if idx != last_idx:
		last_idx = idx
		question_box.TEMP_set_vs_question(p_match_state.questions[idx - 1])
		question_box.play_enter()
	
func count_match_start():
	ready_button.text = "%0*d" % [2, floor(fmod(match_state.intro_time_left,60.0))]
	match_state.intro_time_left = max(match_state.intro_time_left - 1.0, 0.0)
	timer.set_wait_time(1)
	timer.start()
	
			
func _on_ReadyButton_pressed():
	if is_ready: 
		yield(socket.send_match_state_async(matchData.match_id, 2, JSON.print({"ready": "false"})), "completed")
		is_ready = false
		return
		
	yield(socket.send_match_state_async(matchData.match_id, 2, JSON.print({"ready": "true"})), "completed")
	is_ready = true
	ready_button.disabled = true

func _notification(what):  
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		yield(socket.leave_match_async(matchData.match_id), "completed")
		GameManager.scene_manager.go_home()

class VSAnswer: 
	const _SCHEMA = {
		"value": {"name": "value", "type": TYPE_STRING, "required": true},
		"correct": {"name": "correct", "type": TYPE_BOOL, "required": true},
	}
	
	var value : String
	var correct : bool

class VSQuestion:
	const _SCHEMA = {
		"infobyte_id": {"name": "infobyte_id", "type": TYPE_STRING, "required": true},
		"question": {"name": "question", "type": "VSQuestionData", "required": true}
	}

	var infobyte_id: String
	var question : VSQuestionData 

class VSQuestionData: 
	const _SCHEMA = {
		"question": {"name": "question", "type": TYPE_STRING, "required": true},
		"infobit": {"name": "infobit", "type": TYPE_INT, "required": false},
		"answers": {"name": "answers", "type": TYPE_ARRAY, "required": true, "content": "VSAnswer"},
	}


	var question : String
	var infobit : int
	var answers : Array
	 
class VSQuizState:
	
	const _SCHEMA = {
		"presences" : {"name": "presences", "type": TYPE_DICTIONARY, "required": true, "content": TYPE_DICTIONARY},
		"questions" : {"name": "questions", "type": TYPE_ARRAY, "required": false, "content": "VSQuestion"},
		"num_questions" : {"name": "num_questions", "type": TYPE_INT, "required": false},
		"current_question" : {"name": "current_question", "type": TYPE_INT, "required": false},
		"answers" : {"name": "answers", "type": TYPE_ARRAY, "required": false, "content": "VSAnswer"},
		"time_limit_question" : {"name": "time_limit_question", "type": TYPE_REAL, "required": true},
		"time_limit_result" : {"name": "time_limit_result", "type": TYPE_REAL, "required": true},
		"time_limit_intro" : {"name": "time_limit_intro", "type": TYPE_REAL, "required": true},
		"match_started" : {"name": "match_started", "type": TYPE_BOOL, "required": true},
		"show_intro" : {"name": "show_intro", "type": TYPE_BOOL, "required": true},
		"show_questions" : {"name": "show_questions", "type": TYPE_BOOL, "required": true},
		"show_complete" : {"name": "show_complete", "type": TYPE_BOOL, "required": true},
		"intro_time_left" : {"name": "show_complete", "type": TYPE_REAL, "required": true},
		"current_question_time_left" : {"name": "current_question_time_left", "type": TYPE_REAL, "required": true},
		"show_q_result_time" : {"name": "show_q_result_time", "type": TYPE_REAL, "required": true}
	}
	
	var _ex : NakamaException
	var presences : Dictionary
	var questions : Array
	var num_questions : int = 9
	var current_question: int = 0
	var answers : Array
	
	var time_limit_questions : float = 10.0
	var time_limit_result : float = 5.0
	var time_limit_intro : float = 5.0
	
	var match_started : bool = false
	var show_intro : bool = false
	var show_questions : bool = false
	var show_complete : bool = false
	
	var intro_time_left : float = 5.0
	var current_question_time_left : float
	var show_q_result_time : float
