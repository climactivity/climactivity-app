tool
extends Control
class_name ProgressBlips

enum BlipMode {
	INFO,
	QUIZ
}

export (int) var blip_count = 5 setget set_blips
export var mode = BlipMode.INFO setget set_mode
export var active = 0 setget set_active

var ready = false 

func _ready():
	ready = true 
	update()

func set_blips(count):
	blip_count = count 
	update()

func set_mode(_mode):
	mode = _mode 
	update()

func set_active(_active):
	active = _active 
	update()

func update(): 
	if !ready:
		return
