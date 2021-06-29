extends Control

var level
var current_xp
var last_xp
var coins

var inventory = PSS.get_player_state_ref().inventory

onready var level_label = $MarginContainer/HBoxContainer/Level/LevelLabel
onready var coin_label =  $"MarginContainer/HBoxContainer/MarginContainer3/PanelContainer/HBoxContainer/MarginContainer2/Label"
onready var xp_progress = $MarginContainer/HBoxContainer/XPBarHolder/XPBar

func _ready(): 
	_update()
	RewardService.connect("xp_bar_update", self, "_update")
	GameManager.xp_bar = self
#	_avoid_screen_cutouts()
	
func _avoid_screen_cutouts(): 
	var safe_area = OS.get_window_safe_area()
	print (safe_area)
	$MarginContainer.margin_top = $MarginContainer.margin_top + safe_area.position.y
	
func _update(): 
#	return 
	level = inventory.level
	coins = inventory.coins
	current_xp = inventory.xp
	level_label.text = "Level %d" % level
	coin_label.text = "%3d" % coins
	if inventory.xp == 0: 
		visible = false
		return
	if last_xp == null:
		xp_progress.value = RewardService.level_frag(current_xp)
	else:
		var last_frag = RewardService.level_frag(last_xp)
		var current_frag = RewardService.level_frag(current_xp)
		if last_frag > current_frag:
			var tween = $Tween
			tween.interpolate_property($xp_progress, "value",
					last_frag, 1, 1,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_callback(self, 1, "_update")
			tween.start()
		else:
			var tween = $Tween
			tween.interpolate_property($xp_progress, "value",
					last_frag, current_frag, 1,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
	last_xp = current_xp

func show(): 
	$AnimationPlayer.play("show")
