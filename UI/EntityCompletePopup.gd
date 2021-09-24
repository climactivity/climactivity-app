extends Control

signal close

var entity
var tex 
var aspect
var ready = false
var play_enter_anim = false
func _ready():
	ready = true
	update()
	if play_enter_anim:
		_play_enter_anim()

func set_entity(_e, _tex):
	entity = _e
	tex = _tex
	update()

func update(): 
	if !ready or !entity: return
	
	aspect = entity.aspect_id
	var tracking_level = AspectTrackingService.get_current_tracking_level(aspect)

	if tracking_level != null and tracking_level.reward != null and tracking_level.reward.coins != "0": 
		$PanelContainer/VBoxContainer/CoinsContainer/coins_label.text = "+ %d " % int(tracking_level.reward["coins"])
	$PanelContainer/VBoxContainer/ContentText.bbcode_text = tr("entity_complete_message") % [entity.tree_template.ui_name, tex.resource_path]
	$PanelContainer/VBoxContainer/UnlockText.bbcode_text = tr("entity_complete_unlock")

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

func _open_shop():
	if aspect != null:
		GameManager.scene_manager.push_scene("res://Scenes/EntityShopScene.tscn", {"aspect": aspect})
