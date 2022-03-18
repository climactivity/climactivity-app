extends SceneBase


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/Timer

onready var queue_timer_label = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/time_in_queue

onready var mm_button = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/PanelContainer/MarginContainer/PanelContainer/MatchMakerStartButton

onready var name_input = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/NameContainer/MarginContainer/PanelContainer/VBoxContainer/NameInput

var query = "*"
var min_count = 2 
var max_count = 2 
var string_props = {"region": "europe", "mode": "vsquiz"}
var num_props = {"rank": 8}


var socket = null
var matchmaker_ticket : NakamaRTAPI.MatchmakerTicket

var queue_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	mm_button.disabled = false 
	_get_name()
func search_match(): 
	GameManager.menu.hide_menu()
	$AnimationPlayer.play("StartMM")
	socket = NakamaConnection.socket
	socket.connect("received_matchmaker_matched", self, "_on_matchmaker_matched")
	_start_mm()

func _start_mm(): 
	matchmaker_ticket = yield(
		socket.add_matchmaker_async(query, min_count, max_count, string_props, num_props), "completed"
	)
	
	if matchmaker_ticket.is_exception():
		printerr("%s" % matchmaker_ticket)
		return
	print("%s" % matchmaker_ticket)
	
	timer.connect("timeout", self, "count_queue_time")
	queue_time = 0.0
	timer.set_wait_time(1)
	timer.start()
	
func count_queue_time():
	queue_time += 1.0
	
	queue_timer_label.bbcode_text = "[center] %d:%0*d" % [floor(queue_time/60.0),2, floor(fmod(queue_time,60.0))]
	
	timer.set_wait_time(1)
	timer.start()
	

func _cancel_mm(): 
	if matchmaker_ticket == null or socket == null:
		print("An error occurred!")
		return
		
	var removed : NakamaAsyncResult = yield(socket.remove_matchmaker_async(matchmaker_ticket.ticket), "completed")
	
	if removed.is_exception():
		print("An error occurred: %s" % removed)
		return
	
	print("Removed from matchmaking %s" % [matchmaker_ticket.ticket])
	return

func _on_CancelButton_pressed():
	mm_button.disabled = false
	yield(_cancel_mm(), "completed")

	queue_time = 0.0
	timer.stop()
	$AnimationPlayer.play_backwards("StartMM")
	GameManager.menu.show_menu()

func _on_matchmaker_matched(p_matched : NakamaRTAPI.MatchmakerMatched): 
	print("Received MatchmakerMatched message: %s" % [p_matched])
	print("Matched opponents: %s" % [p_matched.users])
	
	var joined_match : NakamaRTAPI.Match = yield(socket.join_matched_async(p_matched), "completed")

	if joined_match.is_exception():
		print("An error occurred: %s" % joined_match)
		_start_mm()
		return
	
	GameManager.scene_manager.push_scene("res://Scenes/VSQuiz.tscn", {"socket": socket, "joined_match": joined_match})


func _on_MatchMakerStartButton_pressed():

	
	mm_button.disabled = true
	
	search_match()


func _on_UpdateNameButton_pressed():
	var name = name_input.text
	var name_changed = yield(NakamaConnection.update_user_name(name), "completed")

func _get_name(): 
	var user : NakamaAPI.ApiUser = yield(NakamaConnection.get_user(), "completed")
	name_input.text = user.display_name
