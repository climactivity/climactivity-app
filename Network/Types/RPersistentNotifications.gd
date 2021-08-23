extends Resource
class_name RPersistentNotifications
export (Array) var notifications = []

func append(notification): 
	notifications.push_front(notification)

func get_all():
	return notifications

func delete(variant):
	notifications.erase(variant)
