extends Node

var notifications = [] setget , get_notifications

signal notification_update
func _ready(): 
	NakamaConnection.connect("notificaion_received", self, "on_notification_received")
	NakamaConnection.connect("nk_connected", self, "fetch_notifications")

func on_notification_received(notification): 
	Logger.print("Notification received", self)
	notifications.push_front(notification)
	emit_signal("notification_update")
func fetch_notifications(): 
	notifications = yield(NakamaConnection.get_notifications(), "completed")
func get_notifications(): 
	return notifications

func has_notifications(): 
	return notifications == null or notifications == []

func dismiss_notification(notification): 
	notifications.erase(notification)
	NakamaConnection.delete_notifications([notification.id])

class NotificationSorter:
	static func sort_desc(a, b):
		return a['sendAt'] > b['sendAt']
