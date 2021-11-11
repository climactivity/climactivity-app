extends Control


onready var connect_box = $VBoxContainer
onready var profile_box = $MarginContainer/VBoxContainer2
onready var profile_box_label = $MarginContainer/VBoxContainer2/Label
onready var support_label = $MarginContainer/VBoxContainer2/SupportLabel
onready var notification_toggle = $MarginContainer/VBoxContainer2/NotificationToggle

func _ready():
	update()
	NakamaConnection.connect("cy_network_authenticated", self, "_authenticated_callback")

func _on_CyButton_pressed():
	NakamaConnection.start_cy_network_oauth_flow()

func update():
	var user =  yield(NakamaConnection.get_user(), "completed")
	if user != null and user.display_name != "": 
		connect_box.visible = false
		profile_box.visible = true
		profile_box_label.bbcode_text = build_profile_desc_text(user)  # "Angemeldet als " + user.display_name # + " (" + user.custom.id  + ")" 
		support_label.bbcode_text = build_support_label_text(user)
		notification_toggle.disabled = false
		_update_settings()
	else: 
		connect_box.visible = true
		profile_box.visible = false
		notification_toggle.disabled = true

func build_profile_desc_text(user):
	var text = "[center]%s" % tr("signed_in_as_label") + user.display_name + "[/center]\n\n"
	text    += "[url=https://climactivity-netzwerk.de/mitglieder/%s][color=#5689A0]Zu meinem Profil[/color] (öffnet sich in externem Browser)[url]" % user.display_name
	return text

func build_support_label_text(user): 
	var text = "[center]Support ID: " + user._username + "[/center]\n\n"
	text    += "[url=%s][color=#5689A0]%s[/color] (öffnet sich in externem Browser)[url]" % [_support_link(user._username), tr("support_link_label")]
	return text

func _support_link(for_user): 
	var link = "mailto:betatest@climactivity.de?subject=Support Anfrage CY App&body="
	link    += "App Version: %s%%0A" % ProjectSettings.get_setting("application/config/version")
	link    += "App Os: %s%%0A" % OS.get_name()
	link    += "Support ID: %s%%0A%%0A" % for_user 
	return link

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

func _on_NotificationToggle_toggled(button_pressed):
	notification_toggle.pressed = button_pressed
	notification_toggle.disabled = true
	yield(NakamaConnection.set_client_setting("notifications", {"enabled": button_pressed}), "completed")
	notification_toggle.disabled = false

var logout_popup = preload("res://UI/LogoutPopup.tscn")

func _on_LogoutButton_pressed():
	GameManager.overlay._show_popup(logout_popup.instance())

func _on_Label_meta_clicked(meta):
	Util.open_link(meta)

func _on_SupportLabel_meta_clicked(meta):
	OS.shell_open(meta)
