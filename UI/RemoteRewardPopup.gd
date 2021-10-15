extends Control

signal close

export (Dictionary) var data

var ready = false
var play_enter_anim = false

func _ready():
	ready = true
	update()
	if play_enter_anim:
		_play_enter_anim()

func set_data(_data):
	data = _data
	update()
	
func update(): 
	if !ready: return
	$PanelContainer/VBoxContainer/RewardMessage.bbcode_text = data.data.meta.message
	$PanelContainer/VBoxContainer/CoinsContainer/coins_label.text = "+ %d " % data.data.reward.coins

func _enter_tree():
	if ready:
		_play_enter_anim()
	else:
		play_enter_anim = true

func _play_enter_anim(): 
	$AnimationPlayer.play("Enter")


func _on_CloseButton_pressed():
	emit_signal("close")
	$AnimationPlayer.play("Leave")
	RemoteMessageService.ackMessage(data)
