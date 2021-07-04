tool
extends Control
class_name RewardLabel

export (Resource) var _reward setget set_reward, get_reward
enum SIZE {normal, big}
export (SIZE) var label_size setget set_label_size

var ready = false

var normal_font = preload("res://UI/typography/UI_Regular.tres")
var big_font = preload("res://UI/typography/UI_big.tres")


func _ready():
	ready = true
	update()

func set_label_size(_size):
	label_size = _size
	
func set_reward(reward):
	_reward = reward
	update()
	
func get_reward():
	return _reward
	
func update():
	if !ready:
		return
	if _reward != null:
		
		var coins_str = ("%s" % str(_reward.coins) ) if _reward.get("coins") else ""
		var xp_str = ("%s" % str(_reward.xp) ) if _reward.get("xp") else ""
		
		$HBoxContainer/coins_label.text = coins_str
		$HBoxContainer/xp_label.text = xp_str
		
		$HBoxContainer/coins_icon_holder.visible = coins_str != ""
		$HBoxContainer/xp_icon_holder.visible = xp_str != ""
		
		if coins_str == "" and xp_str == "": 
			visible = false
		match label_size:
			SIZE.normal:
				$HBoxContainer/coins_icon_holder.rect_min_size = Vector2(40,40)
				$HBoxContainer/xp_icon_holder.rect_min_size = Vector2(40,40)
				$HBoxContainer/coins_label.set("custom_fonts/font", normal_font )
				$HBoxContainer/xp_label.set("custom_fonts/font", normal_font )
			SIZE.big:
				$HBoxContainer/coins_icon_holder.rect_min_size = Vector2(80,80)
				$HBoxContainer/xp_icon_holder.rect_min_size = Vector2(80,80)
				$HBoxContainer/coins_label.set("custom_fonts/font", big_font )
				$HBoxContainer/xp_label.set("custom_fonts/font", big_font )
