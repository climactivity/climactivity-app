extends Control

signal close

export (int) var level setget set_level_up_to

var level_data = {}
var ready = false
var play_enter_anim = false
var unlocks = []
func _ready():
	ready = true
	update()
	if play_enter_anim:
		_play_enter_anim()


func set_level_up_to(_level): 
	level = _level
	level_data = LevelLut.get_level_by_level(level)
	# get unlocks
	var templates = TreeTemplateFactory.get_all_templates()
	unlocks = []
	for template in templates: 
		if templates[template].unlock_level == level:
			unlocks.append(templates[template])
	update()
	
func update(): 
	if !ready or !level_data: return
	$PanelContainer/VBoxContainer/ContentText.bbcode_text = tr("level_up_message") % level

	$PanelContainer/VBoxContainer/CoinsContainer/coins_label.text = "+ %d " % level_data["bonus_coins"]
	if unlocks == []:
		$PanelContainer/VBoxContainer/UnlockText.visible = false
	else:
		var unlock0 = unlocks[0]
		var name = unlock0.template_name
		var preview = unlock0.preview_texture.resource_path
		$PanelContainer/VBoxContainer/UnlockText.bbcode_text = tr("level_up_unlock") % [name, preview]
func _enter_tree():
	if ready:
		_play_enter_anim()
	else:
		play_enter_anim = true

func _play_enter_anim(): 
	$AnimationPlayer.play("Enter")


func _on_CloseButton_pressed():
	emit_signal("close")
