tool 
extends PanelContainer

var was_pressed = false

func _ready():
	pass 

func pressed(): 
	print("[%s] pressed" % self.name)

func _on_ImportantActionButton_gui_input(event):
	if event is InputEventScreenTouch:
		if was_pressed: 
			if !event.pressed and get_rect().has_point(event.position):
				pressed() 
		was_pressed = event.pressed

