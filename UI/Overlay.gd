extends Control
class_name Overlay
onready var anim_player = $AnimationPlayer
onready var popup_content = $Popup/MarginContainer
func _ready():
	GameManager.overlay = self

func _show_popup(control):
	anim_player.play("ShowPopupLayer")
	$Popup.add_child(control)

func _on_Popup_gui_input(event):
	if event is InputEventMouseButton: 
		if event.pressed: 
			_close_popup()


func _on_Close_Button_pressed():
	_close_popup()


func _close_popup(): 
	anim_player.play_backwards("ShowPopupLayer")
	$Popup.clear()

func show_dialog(timeline_name: String):
	var dialog_box = Dialogic.start(timeline_name, false)
	add_child(dialog_box)
	dialog_box.connect("timeline_end", self, "after_dialog")

func dialog_timeline_completed(timeline_name: String):
	Logger.print("Finished dialog %s" % timeline_name, self)
