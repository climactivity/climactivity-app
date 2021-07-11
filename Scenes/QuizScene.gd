extends SceneBase
class_name QuizScene

signal next_infobit
signal next_question
signal prev_infobit
signal prev_question
signal check_answer

onready var anim_player = $AnimationPlayer

export (Dictionary) onready var preloaded_quiz_data

export (NodePath) onready var loading_anim 
export (NodePath) onready var continue_button 
export (NodePath) onready var back_button 
export (NodePath) onready var infobit_holder 
export (NodePath) onready var questions_holder 
export (NodePath) onready var quiz_end
export (NodePath) onready var front_matter
export (NodePath) onready var progress_blips

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

var reshow = false
var wait_check = false 

func _ready():
	front_matter = get_node(front_matter)
	loading_anim  = get_node(loading_anim)
	continue_button  = get_node(continue_button)
	back_button = get_node(back_button)
	infobit_holder = get_node(infobit_holder)
	questions_holder = get_node(questions_holder)
	quiz_end = get_node(quiz_end)
	progress_blips = get_node(progress_blips)
	
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
	if preloaded_quiz_data != {}: 
		receive_navigation(preloaded_quiz_data)

func receive_navigation(_quiz_data):
	quiz_data = _quiz_data.quiz
	set_screen_title(quiz_data.name)
	set_accent_color(_quiz_data.sector["sector_color"])
	set_header_icon(_quiz_data.aspect.icon  if _quiz_data.aspect.icon != null else _quiz_data.sector["sector_logo"])
	if is_instance_valid(Logger):
		Logger.print( "Loaded quiz %s" % [quiz_data.name], self)
	_on_quiz_data(quiz_data)

func _on_quiz_data(quiz_data):
#	header.set_screen_label(quiz_data.name)
	front_matter.set_text(quiz_data.name)
	loading_anim.loading_finished()
	infobit_holder.set_infobits_data(quiz_data.info_bits)
	questions_holder.on_data(quiz_data.questions)

func _finished_loading(): 
	anim_player.play("show_frontmatter")
	state = InfoByteState.FRONT

func _show_infobits():
	print("showing infobits")
	state = InfoByteState.INFO
	anim_player.play("show_infobit_holder")
	progress_blips.set_mode(ProgressBlip.BlipMode.INFO)
	var blip_count = quiz_data.info_bits.size()
	print("blip_count: ",blip_count)
	progress_blips.set_blips(blip_count)
	progress_blips.set_active(0)
	
func _next_infobit(): 
	if reshow:
		reshow = false
		return
	emit_signal("next_infobit") 
	print("next_infobit")
	back_button.set_disabled(false)
	progress_blips.next()
	
func _prev_infobit(): 
	emit_signal("prev_infobit")
	print("prev_infobit")
	progress_blips.prev()
	
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
#	var quiz_end_node = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/QuizEnd"
#	var quiz_end_comment = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/QuizEnd/kiko_avatar - placeholder"
#	var quiz_end_result_text = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/QuizEnd/Label"
#	var quiz_end_collect_button = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/QuizEnd/CollectRewardButton"
#	var quiz_reward_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/QuizEnd/Panel/RewardLabel"
	
	quiz_end.set_result(quiz_result)
	quiz_end.set_quiz(quiz_data)

	anim_player.play("show_quiz_result")
	state = InfoByteState.QUIZ_COMPLETE
	continue_button.set_text("Zur Auswahl")
	continue_button.set_disabled(false)
	
func _content_anim_finished():
	pass
	
func _reshow_frontmatter(): 
	state = InfoByteState.FRONT
	anim_player.play("RESET")
	anim_player.queue("show_frontmatter")
	#infobit_holder.set_infobits_data(quiz_data.infobits)
	
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
			if can_exit:
				GameManager.scene_manager.pop_scene()
		InfoByteState.ERROR:
			pass

func _nav_back():
	GameManager.scene_manager.pop_scene()
	
func _on_back_button():
	match(state):
#		InfoByteState.LOADING:
#			GameManager.scene_manager.pop_scene()
#		InfoByteState.FRONT:
#			GameManager.scene_manager.pop_scene()
		InfoByteState.INFO:
			_prev_infobit()
		InfoByteState.QUIZ_INTRO:
			_show_infobits()
			reshow = true
		InfoByteState.QUIZ:
			_prev_question()
		_:
			pass

# passed of to extra function so the header back button can hook in even if the local back button is disabled
func _on_BackButton_pressed():
	_on_back_button()

var can_exit = false
func _on_CollectRewardButton_pressed():
	if can_exit: 
		return
	InfobyteService.complete_infobyte(quiz_data._id)
	RewardService.add_reward(quiz_data.reward, true)
	can_exit = true
	$"ContentContainer/Content/VBoxContainer/MarginContainer/VSplitContainer/ContentHolder/QuizEnd/CollectRewardButton".set_disabled(true)


func _on_direct_to_quiz_button_pressed():
	_show_quiz()
