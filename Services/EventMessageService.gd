extends Node

signal events_updated

var current_events = [] setget , get_current_events
var event_flags_persist_path = "user://EventMessageService.cfg"
var flags

func _ready():
	nc.connect("remote_conifg_loaded", self, "event_notifications_loaded")
	flags = ConfigFile.new()
	var err = flags.load(event_flags_persist_path)
	if err == OK: 
		print("loaded EventMessagesConfig")
	else:
		# event_flags = {"EventNotificationsSeen": {}}
		flags.save(event_flags_persist_path)

func event_notifications_loaded(): 
	var events =  nc.get("events/eventMessages")
	if events != null: 
		for event in events: 
			var notify_from = Util.parse_date_to_unix(event["notifyFrom"])
			var notify_till = Util.parse_date_to_unix(event["notifyTill"])
			var now = OS.get_unix_time()
			if notify_from <= now and now <= notify_till:
				print([notify_from,now,notify_till])
				current_events.push_back(event)
			
			# local notifications notifications 
			if now <= notify_till: 
				if not(event.has("eventKey") and flags.get_value("EventNotificationsSeen", event.eventKey, 0) != 0):
					NotificationService.put_local_notification(tr("notification_title_cy_event"), event.message, Util.parse_date_to_unix(event["notifyFrom"]) )

	
func dispatch_event_notification(): 
	emit_signal("events_updated") 

func get_current_events():
	return current_events

func has_current_events(): 
	return current_events != []

func should_alert(): 
	if !has_current_events(): return
	var alert = false
	for event in current_events: 
		if not(event.has("eventKey") and flags.get_value("EventNotificationsSeen", event.eventKey, 0) != 0):
			alert = true
			break
			
	return alert

func ackEvent(key): 
	flags.set_value("EventNotificationsSeen", key, OS.get_unix_time()) 
	flags.save(event_flags_persist_path)

func ack_current(): 
	for event in current_events: 
		if event.has("eventKey"):
			ackEvent(event.eventKey)
