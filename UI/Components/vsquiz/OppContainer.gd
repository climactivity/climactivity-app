extends PanelContainer


export(String) var opp_name : String setget set_name
export(bool) var finished : bool setget set_finished
export(bool) var correct : bool setget set_correct 
export(bool) var show_result : bool setget set_show_result 
func set_name(p_name: String) -> void:
	opp_name = p_name
	$HBoxContainer/OpponentLabel.text = p_name
	
func set_finished(p_finished: bool) -> void: 
	if !is_inside_tree(): return
	finished = p_finished
	if finished:
		$HBoxContainer/AspectRatioContainer/OpponentFinished.modulate = Color.green
	else: 
		$HBoxContainer/AspectRatioContainer/OpponentFinished.modulate = Color.white
		self_modulate = Color.gray
		
func set_correct(p_correct: bool) -> void: 
	if !is_inside_tree(): return
	correct = p_correct
#	if finished: 
#		if correct: 
#			self_modulate = Color.lightgreen
#		else:
#			self_modulate = Color.lightcoral
#	else:
#		self_modulate = Color.gray

func set_show_result(p_show_result: bool) -> void: 
	if !is_inside_tree(): return
	show_result = p_show_result
	if show_result:
		if finished: 
			if correct: 
				self_modulate = Color.lightgreen
			else:
				self_modulate = Color.lightcoral
		else:
			self_modulate = Color.gray
	else:
		self_modulate = Color.gray
