extends PanelContainer


onready var text_content = $PanelContainer/MarginContainer/HBoxContainer/RichTextLabel
onready var action_button = $PanelContainer/MarginContainer/HBoxContainer/ActionButton
export var dismiss_threshold = 400.0
var notification
var clickable_link = ''
func _ready():
	update()

func set_notification(_notification): 
	notification = _notification
	update()



func update(): 
	if text_content == null or notification == null: return 
	var content = JSON.parse(notification.content).result
	if !content.has("messageType"):
		return
	match content.messageType:
		"Notification":
			var href = content.text.split("\"")[1]
			var text = content.text.split(">")[1].split("<")[0]
			text_content.bbcode_text = '%s' % [text] 
			clickable_link = href
		_:
			return
 
func _on_ActionButton_pressed():
	if clickable_link != '': 
		OS.shell_open(clickable_link)

func dismiss():
	NotificationService.dismiss_notification(notification)
	$AnimationPlayer.play("Dismiss")

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
