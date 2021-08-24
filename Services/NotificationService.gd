extends Node

export (String) var notification_persist_path = "user://notifications.tres"
var persistent_notifications = load("user://notifications.tres")
var ephemeral_notifications = []
func ready(): 
	NakamaConnection.connect("notificaion_received", self, "on_notification_received")
	if persistent_notifications == null: 
		persistent_notifications = RPersistentNotifications.new()
		persistent_notifications.take_over_path(notification_persist_path)
		ResourceSaver.save(notification_persist_path, persistent_notifications,32)

func on_notification_received(notification): 
	if notification.has("persist"): 
		_persist_notification(notification)
	else:
		ephemeral_notifications.push_front(notification)

func _persist_notification(notification): 
	persistent_notifications.append(notification)
	ResourceSaver.save(notification_persist_path, persistent_notifications,32)

func get_notifications(): 
	var _notifications: Array =  persistent_notifications.get_all() + ephemeral_notifications
	_notifications.sort_custom(NotificationSorter, "sort_desc")

func dismiss_notification(notification): 
	pass

class NotificationSorter:
	static func sort_desc(a, b):
		return a['sendAt'] > b['sendAt']
