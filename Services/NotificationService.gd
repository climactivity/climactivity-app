extends Node

var notifications = [] setget , get_notifications
var local_notifications_inited = false
signal notification_update
signal local_notifications_inited
func _ready(): 
	NakamaConnection.connect("notificaion_received", self, "on_notification_received")
	NakamaConnection.connect("nk_connected", self, "fetch_notifications")
	localnotification.connect("lib_inited", self, "init_local_notifications")

func on_notification_received(notification): 
	Logger.print("Notification received", self)
	notifications.push_front(notification)
	if local_notifications_inited:
		_put_nk_notification(notification.code)
	emit_signal("notification_update")
func fetch_notifications(): 
	notifications = yield(NakamaConnection.get_notifications(), "completed")
func get_notifications(): 
	return notifications

func has_notifications(): 
	return not notifications == null or notifications == []

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
				print("ln req permissions")
				localnotification.connect("enabled", self, "init_local_notifications")
				localnotification.init()
		"Android":
			return true
		_:
			return false 

func _put_nk_notification(notification):
	if notification == null: return 
	var content = JSON.parse(notification.content).result
	if !content.has("messageType"):
		Logger.error("This should not be shown to the user like this", self)
		return
	match content.messageType:
		"Notification":
			var text = content.text.split(">")[1].split("<")[0]
			put_local_notification(tr("notification_title_network"), text, notification.code)
		_:
			return

func put_local_notification(title: String, message: String, tag: int = 0, date = OS.get_unix_time(), repeat_duration: int = 0) -> int:
	if !local_notifications_inited:
		init_local_notifications()
		yield(self, "local_notifications_inited")
	# if none provided make a tag to refer to the notification later
	if tag == 0: 
		tag = randi() % 1000 + 1000
	var current_notifications = localnotification.get_notification_data()
	
	if date < OS.get_unix_time(): 
		date = OS.get_unix_time()
	var interval =  min(date - OS.get_unix_time(),10)
	Logger.print("triggering notification %s in %d" % [title, interval])
	localnotification.show(message, title, interval, tag, repeat_duration)
	return tag

func init_local_notifications(): 
	local_notifications_inited = local_notificaionts_inited()
	if local_notifications_inited: 
		print("Notifications initialized!")
#		localnotification.show("Hello", "It works", 30, 1) 
		print("Notification Data: ", localnotification.get_notification_data())
		emit_signal("local_notifications_inited")
	else:
		print("Notifications failed initialization, prompt permission?")

class NotificationSorter:
	static func sort_desc(a, b):
		return a['sendAt'] > b['sendAt']
