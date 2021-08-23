extends Node

export (String) var notification_persist_path = "user://notifications.tres"
var persistent_notifications = load("user://notifications.tres")

func ready(): 
	NakamaConnection.connect("notificaion_received", self, "on_notification_received")
	if persistent_notifications == null: 
		persistent_notifications = RPersistentNotifications.new()
		persistent_notifications.take_over_path(notification_persist_path)
		ResourceSaver.save(notification_persist_path, persistent_notifications,32)

func on_notification_received(notification): 
	if notification.has("persist"): 
		_persist_notification(notification)

func _persist_notification(notification): 
	persistent_notifications.append(notification)
	ResourceSaver.save(notification_persist_path, persistent_notifications,32)
