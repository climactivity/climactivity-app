extends Node

export (String) var notification_persist_path = "user://notifications.tres"
var persistent_notifications = load("user://notifications.tres")

func ready(): 
	NakamaConnection.connect("notificaion_received", self, "on_notification_received")

func on_notification_received(notificaion): 
	pass

func _persist_notification(): 
	pass
