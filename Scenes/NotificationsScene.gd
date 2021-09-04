extends SceneBase

var notifications = []

export (PackedScene) var bp_notification_card

onready var content_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain"

func _restored(): 
	notifications = NotificationService.get_notifications()
	for notification in notifications: 
		var inst = bp_notification_card.instance()
		content_holder.add_child(inst)
		inst.set_notification(notification)
