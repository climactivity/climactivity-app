extends PanelContainer


onready var text_content = $PanelContainer/MarginContainer/HBoxContainer/RichTextLabel
onready var action_button = $PanelContainer/MarginContainer/HBoxContainer/ActionButton
export var dismiss_threshold = 400.0
var event
var clickable_link = ''
func _ready():
	update()

func set_event(_event): 
	event = _event
	update()



func update(): 
	if text_content == null or event == null: return 
	var content = event.message

	text_content.bbcode_text = content 


 
func _on_ActionButton_pressed():
	if clickable_link != '': 
		OS.shell_open(clickable_link)

func dismiss():
#	NotificationService.dismiss_notification(notification)
#	$AnimationPlayer.play("Dismiss")
	pass

var last_down = Vector2.ZERO
var dragging = false

func _on_Notification_gui_input(event):
	if event is InputEventScreenTouch and  event.index == 0:
		dragging = event.pressed
		if !dragging:
			$Tween.interpolate_property($PanelContainer, "rect_position", $PanelContainer.rect_position, Vector2(0, $PanelContainer.rect_position.y), 0.6,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			$Tween.interpolate_property($PanelContainer, "modulate", $PanelContainer.modulate, Color.white, 0.6,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
			$Tween.start()
		else:
			$Tween.stop_all()
	if event is InputEventScreenDrag: 
		$PanelContainer.rect_position.x += event.relative.x
		event.position = last_down
		$PanelContainer.modulate = Color( 1.0, 1.0, 1.0, Util.map_to_range(abs($PanelContainer.rect_position.x),0.0,dismiss_threshold,1.0,0.0) )
		if $PanelContainer.rect_position.x > dismiss_threshold:
			dismiss()


func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)


func _on_RichTextLabel_gui_input(event):
	_on_Notification_gui_input(event)
