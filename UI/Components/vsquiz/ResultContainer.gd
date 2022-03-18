extends PanelContainer

onready var own_name_label = $VBoxContainer/Ratio/YouContainer/HBoxContainer/OwnNameLabel
onready var opponent_name_label = $VBoxContainer/Ratio/OppContainer/HBoxContainer/OpponentLabel

onready var own_score_label = $VBoxContainer/ResultDetails/YouContainer/HBoxContainer/OwnScoreLabel
onready var opponent_score_label = $VBoxContainer/ResultDetails/OppContainer/HBoxContainer/OpponentScoreLabel

onready var ratio_panel = $VBoxContainer/Ratio/YouContainer
onready var result_label_holder = $VBoxContainer/ResultLabelHolder

var ratio = 1.0 

func set_state(p_result: Dictionary, p_own_name : String, p_opponent_name : String, p_own_session_id : String, p_opponent_session_id : String): 

	own_name_label.text = p_own_name
	opponent_name_label.text = p_opponent_name

	var own_result: VSQuizAPI.VSMatchPlayerResult = p_result[p_own_session_id]
	var opponent_result: VSQuizAPI.VSMatchPlayerResult = p_result[p_opponent_session_id]
		
	var result = 'draw'
	var result_state = p_result.state
	
	if result_state.type == "win":
		var winner_session_id = result_state["winner"]["session_id"]
		if winner_session_id == p_own_session_id:
			result = 'win'
		else:
			result = 'loss'

	result_label_holder.set_result(result)
	var own_score = own_result.total_correct
	own_score_label.text = "%d" % own_score
	var opponent_score = opponent_result.total_correct
	opponent_score_label.text = "%d" %  opponent_score
	ratio = _get_ratio(own_score, opponent_score)

func play_enter(): 
	$AnimationPlayer.play("Enter")
	
func _animate_ratio(): 
	$Tween.interpolate_property(
		ratio_panel,
		"size_flags_stretch_ratio",
		1.0,
		ratio,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	
func _get_ratio(p_own_score, p_opponent_score): 
	var ratio = 1.0
	if p_own_score == 0 and p_opponent_score == 0: 
		return 1.0
	elif p_own_score == 0: 
		return 0.1
	elif p_opponent_score == 0: 
		return 10.0 
	else: 
		return float(p_own_score) / float(p_opponent_score)
