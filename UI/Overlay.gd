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
	dialog_box.connect("timeline_end", self, "dialog_timeline_completed")
	$AnimationPlayer.play("ShowDialog")

func dialog_timeline_completed(timeline_name: String):
	Logger.print("Finished dialog %s" % timeline_name, self)
	$AnimationPlayer.play("HideDialog")

var available_timeline = ''
var hidden = true
func show_available_tutorial(timeline):
	available_timeline = timeline
	if hidden:
		$AnimationPlayer.play("show_available_tutorial")
		hidden = false

func hide_available_tutorial():
	available_timeline = ''
	yield(get_tree().create_timer(0.1), "timeout")
	if available_timeline == '':
		$AnimationPlayer.play_backwards("show_available_tutorial")
		hidden = true

func _on_TextureButton_pressed():
	if available_timeline != '': 
		show_dialog(available_timeline)
