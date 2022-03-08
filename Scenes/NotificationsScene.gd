extends SceneBase

var notifications = []
var event_messages = []
export (PackedScene) var bp_notification_card
export (PackedScene) var bp_event_card
onready var content_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer2/VBoxContainer"
onready var events_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/SystemMessages/VBoxContainer"
onready var no_notifications_message = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/VBoxContainer/Label"
onready var oauth_reminder = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/VBoxContainer/OAuthReminder

func _ready():
	NotificationService.connect("notification_update", self, "_restored")
	EventMessageService.connect("events_updated", self, "_restored")
	
func _restored(): 
	Util.clear(content_holder)
	Util.clear(events_holder)
	notifications = NotificationService.get_notifications()
	event_messages = EventMessageService.get_current_events()
	no_notifications_message.visible = (notifications == null or notifications.size() == 0) and !EventMessageService.has_current_events()
#	var user = yield(NakamaConnection.get_user(),"completed")
#	if user != null and user.display_name != "": 
#		oauth_reminder.visible = false
		
	for notification in notifications: 
		var inst = bp_notification_card.instance()
		content_holder.add_child(inst)
		inst.set_notification(notification)

	for event_message in event_messages: 
		var inst = bp_event_card.instance()
		events_holder.add_child(inst)
		inst.set_event(event_message)
		
func _on_OAuthReminderButton_pressed():
	GameManager.scene_manager.push_scene("settings_scene")
