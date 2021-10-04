extends CyMenuButton

func _ready():
	_set_alert()
	
func _set_alert():
	if NotificationService.has_notifications() or EventMessageService.should_alert():
		set_alert_visible(true)
		$MarginContainer/VBoxContainer/tex/Control/bgAlert.visible = true
	if EventMessageService.should_alert():
		$AnimationPlayer.play("Alert")

func _on_button_pressed():
	emit_signal("pressed")
	set_alert_visible(false)
	$MarginContainer/VBoxContainer/tex/Control/bgAlert.visible = false
	$AnimationPlayer.stop()
	EventMessageService.ack_current()
