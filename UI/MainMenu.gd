extends Control
class_name MainMenu
enum Navigation_states {
	HOME,
	NOTIFICATIONS,
	SOCIAL,
	STATS,
	SETTINGS
}

var navigation_state = Navigation_states.HOME setget set_navigation_state

onready var anim_player = $AnimationPlayer
onready var home_button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/HomeButton
onready var notification_button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/NotificationButton
onready var stats_button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/StatsButton
onready var social_button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/SocialButton
onready var settings_button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/SettingsButton
var buttons
func _ready():
	buttons = [home_button, notification_button, stats_button, social_button, settings_button]
	set_navigation_state(navigation_state, true)
	if GameManager != null:
		GameManager.menu = self

func hide_menu(): 
	Logger.print("Hiding Menu", self)
	if visible: 
		anim_player.play("Hide")

func show_menu(): 
	Logger.print("Showing Menu", self)
	if !visible:
		anim_player.play("Show")

func _on_HomeButton_pressed():
	Logger.print("HomeButton pressed", self)
	set_navigation_state(Navigation_states.HOME)

func _on_NotificationButton_pressed():
	Logger.print("NotificationButton pressed", self)
	set_navigation_state(Navigation_states.NOTIFICATIONS)
	
func _on_StatsButton_pressed():
	Logger.print("StatsButton pressed", self)
	set_navigation_state(Navigation_states.STATS)
	
func _on_SocialButton_pressed():
	Logger.print("SocialButton pressed", self)
	set_navigation_state(Navigation_states.SOCIAL) 
	
func _on_SettingsButton_pressed():
	Logger.print("SettingsButton pressed", self)
	set_navigation_state(Navigation_states.SETTINGS)
	
func set_navigation_state(new_state, stay = false): 
	navigation_state = new_state
	for button in buttons: 
		button.self_modulate = Color.gray
	match navigation_state:
		Navigation_states.HOME:
			home_button.self_modulate = Color.cornflower
			if !stay: _navigate_home()
		Navigation_states.NOTIFICATIONS:
			notification_button.self_modulate = Color.cornflower
			if !stay: _navigate_notifications()
		Navigation_states.SOCIAL:
			social_button.self_modulate = Color.cornflower
			if !stay: _navigate_social()
		Navigation_states.STATS:
			stats_button.self_modulate = Color.cornflower
			if !stay: _navigate_stats()
		Navigation_states.SETTINGS:
			settings_button.self_modulate = Color.cornflower
			if !stay: _navigate_settings()
		_:
			pass

func _navigate_home(): 
	if GameManager == null or GameManager.scene_manager == null: return
	GameManager.scene_manager.go_home()
	
func _navigate_notifications(): 
	if GameManager == null or GameManager.scene_manager == null: return
	GameManager.scene_manager.push_scene("notifications_scene")
	
func _navigate_social(): 
	if GameManager == null or GameManager.scene_manager == null: return
	GameManager.scene_manager.push_scene("social_scene")
	
func _navigate_stats(): 
	if GameManager == null or GameManager.scene_manager == null: return
	GameManager.scene_manager.push_scene("stats_scene")
	
func _navigate_settings(): 
	if GameManager == null or GameManager.scene_manager == null: return
	GameManager.scene_manager.push_scene("settings_scene")
