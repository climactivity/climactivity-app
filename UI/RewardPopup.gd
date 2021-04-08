extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal close

var _reward setget set_reward

onready var xp_panel = $"VBoxContainer/MarginContainer/HBoxContainer/XP_Display"
onready var xp_label = $"VBoxContainer/MarginContainer/HBoxContainer/XP_Display/MarginContainer2/CenterContainer/XP_Label"
onready var coin_panel = $"VBoxContainer/MarginContainer/HBoxContainer/Coin_Display"
onready var coin_label = $"VBoxContainer/MarginContainer/HBoxContainer/Coin_Display/MarginContainer3/CenterContainer2/Coin_Label"
# Called when the node enters the scene tree for the first time.
func _ready():
	if _reward != null:
		_show_reward()

func set_reward(reward):
	_reward = reward
	_show_reward()
	
func _show_reward():
	if _reward.xp > 0and xp_panel != null:
		xp_panel.visible = true
		xp_label.text = "+ %d XP" % _reward.xp
	if _reward.coins > 0 and coin_panel != null:
		coin_panel.visible = true
		coin_label.text = "+ %d Taler" % _reward.coins
func _on_AcceptButton_pressed():
	emit_signal("close")
