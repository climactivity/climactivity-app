extends Control
class_name Overlay

signal popup_show
signal popup_hide

onready var anim_player = $AnimationPlayer
onready var popup_content = $Popup/MarginContainer
func _ready():
	GameManager.overlay = self
#	$TextureButton.set_position(Vector2($TextureButton.get_position().x, get_viewport_rect().size.y - $TextureButton.rect_size.y))
	$MainMenu.connect("show_menu", self, "_tutorial_button_avoid_menu", [true])
	$MainMenu.connect("hide_menu", self, "_tutorial_button_avoid_menu", [false])
	$TextureButton/kiko.rect_position.y -= OS.get_window_safe_area().position.y/2
func _show_popup(control):
	if $Popup.has_popup():
		return
	anim_player.play("ShowPopupLayer")
	$Popup.add_child(control)
	emit_signal("popup_show")
	control.connect("close", self,"_close_popup")
func _on_Popup_gui_input(event):
	if event is InputEventMouseButton: 
		if event.pressed: 
			_close_popup()


func _on_Close_Button_pressed():
	print("close button clicked")
	_close_popup()

func _tutorial_button_avoid_menu(show_menu):
#	pass
	print("_tutorial_button_avoid_menu: ", show_menu)
#	$TextureButton.rect_position.y += -250.0 if show_menu else  250.0


func _close_popup(): 
	anim_player.play_backwards("ShowPopupLayer")
	$Popup.clear()
	emit_signal("popup_hide")

func show_dialog(timeline_name: String):
	var dialog_box = Dialogic.start(timeline_name, false)
	add_child(dialog_box)
	dialog_box.connect("timeline_end", self, "dialog_timeline_completed")
	$AnimationPlayer.play("ShowDialog")

func dialog_timeline_completed(timeline_name: String):
	Logger.print("Finished dialog %s" % timeline_name, self)
	NakamaConnection.analytics_store_viewed_tutorials()
	$AnimationPlayer.play("HideDialog")

var available_timeline = ''
var hidden = true
func show_available_tutorial(timeline):
	Logger.print("Tutorial %s available" % timeline, self)
	available_timeline = timeline
	if hidden:
		$AnimationPlayer.play("show_available_tutorial")
		$MainMenu/AnimationPlayer.play("KikoCutout")
		hidden = false
	Logger.print($TextureButton.rect_position, self)
func hide_available_tutorial():
	if hidden: 
		Logger.print("Not hinding", self)
		return
	available_timeline = ''
	yield(get_tree().create_timer(0.1), "timeout")
	if available_timeline == '':
		$AnimationPlayer.play_backwards("show_available_tutorial")
		$MainMenu/AnimationPlayer.play_backwards("KikoCutout")
		hidden = true

func _on_TextureButton_pressed():
#	Logger.print("play timeline?")
	if available_timeline != '': 
		show_dialog(available_timeline)


func _on_CloseDialogButton_pressed():
	Logger.print("close dialog!")
