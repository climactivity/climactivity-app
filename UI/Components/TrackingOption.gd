extends Control


var option_data setget set_tracking_option_data

onready var label = $MarginContainer/HBoxContainer/VBoxContainer/Label
onready var reward_label = $MarginContainer/HBoxContainer/VBoxContainer/Reward

func _ready(): 
	if option_data == null: return
	_update_fields()

func set_tracking_option_data(new_option_data): 
	option_data = new_option_data
	if label != null && reward_label != null:
		_update_fields()
	
func _update_fields(): 
	label.text = option_data.option
	reward_label.set_reward(option_data.reward) 
