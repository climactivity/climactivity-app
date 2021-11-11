extends Node

var notifications = [] setget , get_notifications

signal notification_update
func _ready(): 
	NakamaConnection.connect("notificaion_received", self, "on_notification_received")
	NakamaConnection.connect("nk_connected", self, "fetch_notifications")
	localnotification.connect("lib_inited", self, "init_local_notifications")

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
				print("ln inited")
				return localnotification.is_enabled()
			else: 
				print("ln req permissionss")
				localnotification.connect("enabled", self, "init_local_notifications")
				localnotification.init()
		"Android":
			return true
		_:
			return false 

func init_local_notifications(): 
	var is_initied = local_notificaionts_inited()
	if is_initied: 
		print("Notifications initialized!")
		localnotification.show("Hello", "It works", 30, 1) 
		print("Notification Data: ", localnotification.get_notification_data())
	else:
		print("Notifications failed initialization, prompt permission?")

class NotificationSorter:
	static func sort_desc(a, b):
		return a['sendAt'] > b['sendAt']
