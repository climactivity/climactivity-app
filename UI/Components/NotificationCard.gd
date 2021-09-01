extends PanelContainer


onready var text_content = $HBoxContainer/RichTextLabel
onready var action_button = $HBoxContainer/ActionButton

var notification

func _ready():
	pass

func set_notification(_notification): 
	notification = _notification
	update()
	
func update(): 
	if text_content == null: return 
	text_content.bbcode_text = notification.text
	match notification.type:
		"Notification":
			var href = notification.text.split("\"")[1]
			var text = notification.text.split(">")[1].split("<")[0]
			text_content.bbcode_text = " %s %s " % [href, text] 
		_:
			pass
 
func _on_ActionButton_pressed():
	if notification != null and notification is Dictionary and notification.has("linkTo"): 
		OS.shell_open(notification.linkTo)

func dismiss():
	NotificationService.dismiss_notification(notification)
	$AnimationPlayer.play("Dismiss")
