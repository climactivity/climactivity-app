extends Control


var option_data setget set_tracking_option_data

onready var label = $HBoxContainer/VBoxContainer/Label
onready var reward_label = $HBoxContainer/VBoxContainer/Reward

func _ready(): 
	if option_data == null: return
	label.text = option_data["locale_id"]

func set_tracking_option_data(new_option_data): 
	option_data = new_option_data
	if is_inside_tree():
		label.text = new_option_data["locale_id"]
	
