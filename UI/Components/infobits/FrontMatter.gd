extends InfoSection

signal skip_to_quiz

export var _text = "info_missing" setget set_text
export var completed_infobyte = false setget set_completed_infobyte
onready var kiko = $"VBoxContainer/kiko_avatar - placeholder"
export var autoplay = false

func set_completed_infobyte(_completed_infobyte): 
	completed_infobyte = _completed_infobyte
	update()
func _ready():
	if autoplay:
		enter()
func set_text(text): 
	_text = text 
	if ready: 
		update()

func update(): 
	if !ready: return
	.update()
	if kiko != null:
		kiko.set_text(_text)
	if completed_infobyte: 
		$"VBoxContainer/MarginContainer/SkipQuizButton".disabled = true
	$"VBoxContainer/Label2".visible = completed_infobyte

func _on_PanelContainer_pressed():
	emit_signal("skip_to_quiz")
