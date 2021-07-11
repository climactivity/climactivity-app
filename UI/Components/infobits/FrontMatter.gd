extends InfoSection

signal skip_to_quiz

export var _text = "info_missing" setget set_text
onready var kiko = $"VBoxContainer/kiko_avatar - placeholder"
export var autoplay = false
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

func _on_PanelContainer_pressed():
	emit_signal("skip_to_quiz")
