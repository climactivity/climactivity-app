extends SceneBase
class_name VSQuiz
var matchData : NakamaRTAPI.Match 
var socket : NakamaSocket

var own_presence : NakamaRTAPI.UserPresence

signal current_question(question_idx, time_left, match_state)

var match_state : VSQuizAPI.VSQuizState
var last_match_state_state = false
var is_ready = false 
onready var ready_button = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/ReadyButton

onready var own_name_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/YouContainer/HBoxContainer/OwnNameLabel

onready var opponent_name_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/OppContainer/HBoxContainer/OpponentLabel

onready var opp_container = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Questions/VBoxContainer/OppContainer

onready var self_ready = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/YouContainer/HBoxContainer/AspectRatioContainer/SelfReady

onready var oppnent_ready = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/VBoxContainer/OppContainer/HBoxContainer/AspectRatioContainer/OpponentReady

onready var timer = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Timer

onready var category_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Lobby/PanelContainer/CatergoryLabel

onready var animation_player = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/AnimationPlayer

onready var question_box = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Questions/VBoxContainer/MarginContainer/QuestionBox

onready var question_timer = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Questions/VBoxContainer/Timer

onready var question_timer_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Questions/VBoxContainer/Timer/TimerLabel

onready var summary_container = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/MatchSummary/Layout/SummaryContainer

onready var result_container = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/MatchSummary/Layout/ResultContainer

onready var tween = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/Tween
onready var scroller = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer

var bp_q_summary = preload("res://UI/Components/vsquiz/QuestionSummary.tscn")

var unreadyColor = Color.white
var readyColor = Color.greenyellow
var opponent_presence_id 
var opponent_name
func _start_match(_navigation_data):
	
	match_state = VSQuizAPI.VSQuizState.new()
	
	matchData = _navigation_data.joined_match
	own_presence = matchData.self_user

	_update_opponent()
	
	socket = _navigation_data.socket
	socket.connect("received_match_presence", self, "_update_presences")
	socket.connect("received_match_state", self, "_on_match_state")
	connect("current_question", self, "_update_current_question")
	question_box.connect("answer_changed", self, "_on_answer_selected")
	
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
			var opponent: NakamaAPI.ApiUser = yield(NakamaConnection.get_user_profile_async(p.user_id), "completed")
			opponent_name = opponent.display_name if opponent.display_name != '' else opponent.username
			opponent_name_label.text = opponent.display_name
			opponent_presence_id = p.session_id
			opp_container.set_name(opponent_name) ## fixme

func _on_match_state(p_state: NakamaRTAPI.MatchData):
#	print(p_state)
	var json_result = JSON.parse(p_state.data)
	print(p_state.op_code)
		
	if json_result.error == OK:
		var result = json_result.result
		if result.has("ready") and p_state.presence:
			var affected_presence : NakamaRTAPI.UserPresence = p_state.presence
			if affected_presence.session_id == own_presence.session_id:
				self_ready.modulate = readyColor
			else:
				oppnent_ready.modulate = readyColor
		

		
		elif p_state.op_code > 2 and p_state.op_code < 100:
			
			match_state = VSQuizAPI.VSQuizState.create(VSQuizAPI.new().get_script(), result) 
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
				_update_opponent_state( match_state.current_question, false, match_state )
			if match_state.show_q_result: 
				question_box.check_result()
				_update_opponent_state( match_state.current_question, true, match_state )
			if p_state.op_code == 10:
				_show_match_summary()
		elif p_state.op_code == 1000: 
			match_state = VSQuizAPI.VSQuizState.create(VSQuizAPI.new().get_script(), result) 
			_update_opponent()
func _show_match_summary():
	_interpolate_accent_color(Color.purple)
	_get_winner()
	Util.clear(summary_container)
	for i in range(0,match_state.questions.size()):
		var q_summary = bp_q_summary.instance()
		summary_container.add_child(q_summary)
		q_summary.connect("focus", self, "scroll_to")
		q_summary.set_state(i, match_state, own_presence.session_id, opponent_presence_id, opponent_name_label.text)
		
	animation_player.play("GotoMatchSummary")

var match_result_summary

func _get_winner():
	var result : Dictionary = match_state.result
	if result == null or !result.has("state"): 
		return null
	
	var _match_result_summary = result["state"]
	
	match_result_summary = _match_result_summary

	result_container.set_state(result, own_presence.username, opponent_name_label.text, own_presence.session_id, opponent_presence_id)
	result_container.play_enter()
	return match_result_summary

func scroll_to(node: Node):
	var path = scroller.get_path_to(node)
	scroller.scroll_to_child(path, 50)

func _update_opponent_state(p_q_index: int, p_show_result: bool, p_match_state: VSQuizAPI.VSQuizState):
	opp_container.set_show_result(p_show_result)
	var opp_correct = false 
	var _current_answers = p_match_state.answers[p_q_index - 1]
	if _current_answers.has(opponent_presence_id):
		var opp_ans: VSQuizAPI.VSPlayerAnswer = _current_answers[opponent_presence_id] 

		opp_container.set_finished(true)
		opp_container.set_correct(opp_ans.correct)
	else: 
		opp_container.set_finished(false)
var last_idx = -1 

func _update_current_question(idx: int, time_left: float, p_match_state: VSQuizAPI.VSQuizState):
	question_timer_label.text = "%02d" % max(0.0,floor(time_left))
	var timeleft = (time_left / p_match_state.time_limit_questions) * 100.0

	if idx != last_idx:
		last_idx = idx
		var question = p_match_state.questions[idx-1] # lua is 1-indexed 
		question_box.TEMP_set_vs_question(question)
		question_box.play_enter()
		
		question.infobyte_id
		var new_accent_color = Color.purple
		var infobyte = Api.cache.get_infobyte_by_id(question.infobyte_id)
		var aspect = Api.cache.get_aspect_by_name(infobyte.aspect)		# ew
		var sector = SectorService.get_sector_data(aspect.bigpoint)		# ew		# ew		# ew		# ew		# ew
		new_accent_color = sector["sector_color"]
		_interpolate_accent_color(new_accent_color)
		tween.stop(question_timer, "value")
		question_timer.value = timeleft
		tween.stop(question_timer, "self_modulate")
		tween.interpolate_property(
			question_timer,
			"self_modulate",
			Color.green,
			Color.red,
			p_match_state.time_limit_questions,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.stop(question_timer, "value")
		tween.interpolate_property(
			question_timer,
			"value",
			question_timer.value,
			timeleft,
			1.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT)
		tween.start()

func _interpolate_accent_color(p_color): 
	tween.stop_all()
	tween.interpolate_method(self, "set_accent_color", accent_color, p_color, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func _on_answer_selected(answer : VSQuizAPI.VSAnswer):
	var ans = NakamaSerializer.serialize(answer)
	yield(socket.send_match_state_async(matchData.match_id, 100, JSON.print(ans) ), "completed")

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
		_leave_match()

func _leave_match(): 
	yield(socket.leave_match_async(matchData.match_id), "completed")
	GameManager.scene_manager.go_home()

func _on_ExitButton_pressed():
	_leave_match()
