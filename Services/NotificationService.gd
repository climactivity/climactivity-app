extends Node

var notifications = [] setget , get_notifications

signal notification_update
func _ready(): 
	NakamaConnection.connect("notificaion_received", self, "on_notification_received")
	NakamaConnection.connect("nk_connected", self, "fetch_notifications")
	init_local_notifications()

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


func local_notificaionts_inited(): 
	
	match OS.get_name(): 
		"iOS":
			var initied = localnotification.is_inited()
			if initied: 
				return localnotification.is_enabled()
			else: 
				return yield(localnotification.init(), "enabled")
		"Android":
			return true
		_:
			return false 

func init_local_notifications(): 
	var is_initied = local_notificaionts_inited()
	if is_initied: 
		print("Notifications initialized!")
		localnotification.show("Hello", "It works", 10, 100) 
	else:
		print("Notifications failed initialization!")

class NotificationSorter:
	static func sort_desc(a, b):
		return a['sendAt'] > b['sendAt']
