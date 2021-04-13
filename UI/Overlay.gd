extends Control

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
