extends SceneBase

var notifications = []

export (PackedScene) var bp_notification_card

onready var content_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer2/VBoxContainer"
onready var no_notifications_message = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer"

func _ready():
	NotificationService.connect("notification_update", self, "_restored")

func _restored(): 
	Util.clear(content_holder)
	notifications = NotificationService.get_notifications()
	no_notifications_message.visible = notifications.size() == 0
	for notification in notifications: 
		var inst = bp_notification_card.instance()
		content_holder.add_child(inst)
		inst.set_notification(notification)
