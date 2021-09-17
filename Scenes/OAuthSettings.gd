extends Control


func _on_CyButton_pressed():
	NakamaConnection.connect("cy_network_authenticated", self, "_authenticated_callback")
	NakamaConnection.start_cy_network_oauth_flow()

onready var connect_box = $VBoxContainer
onready var profile_box = $MarginContainer/VBoxContainer2
onready var profile_box_label = $MarginContainer/VBoxContainer2/Label
onready var notification_toggle = $MarginContainer/VBoxContainer2/NotificationToggle

func update():
	var user =  yield(NakamaConnection.get_user(), "completed")
	if user != null and user.display_name != "": 
		connect_box.visible = false
		profile_box.visible = true
		profile_box_label.bbcode_text = "Angemeldet als " + user.display_name # + " (" + user.custom.id  + ")" 
		notification_toggle.disabled = false
		_update_settings()
	else: 
		connect_box.visible = true
		profile_box.visible = false
		notification_toggle.disabled = true

var settings = {}

func _update_settings(): 
	settings = yield(NakamaConnection.get_client_settings(), "completed")
	if settings == null:
		settings = {}
	if settings.has("notifications"): 
		var notification_settings = settings["notifications"]
		if notification_settings.has("enabled"): 
			notification_toggle.pressed = notification_settings["enabled"]
		else: 
			notification_toggle.pressed = true
			NakamaConnection.set_client_setting("notifications", {"enabled": true})
	
func _authenticated_callback(): 
	update()
func _ready():
	update()


func _on_NotificationToggle_toggled(button_pressed):
	notification_toggle.pressed = button_pressed
	notification_toggle.disabled = true
	yield(NakamaConnection.set_client_setting("notifications", {"enabled": button_pressed}), "completed")
	notification_toggle.disabled = false
