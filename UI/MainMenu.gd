extends Control
class_name MainMenu
enum Navigation_states {
	HOME = 0,
	NOTIFICATIONS = 1,
	SOCIAL = 3,
	STATS = 2,
	SETTINGS = 4
}

export (Color) var active_tab_primary = Color("#f5af19")
export (Color) var inactive_tab_primary = Color("#95c11e")
export (Color) var disabled_tab_primary = Color("#636362")
var navigation_state = Navigation_states.HOME setget set_navigation_state
var last_navigation_state = Navigation_states.HOME
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
	_avoid_screen_cutouts()
	
func _avoid_screen_cutouts(): 
	var safe_area = OS.get_window_safe_area()
	var container = $MarginContainer/PanelContainer
	
	container.margin_top = container.margin_top - safe_area.position.y
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
	last_navigation_state = navigation_state
	navigation_state = new_state
	for button in buttons: 
		button.set_primary_color(inactive_tab_primary)
	match navigation_state:
		Navigation_states.HOME:
			home_button.set_primary_color(active_tab_primary)
			if !stay: _navigate_home()
		Navigation_states.NOTIFICATIONS:
			notification_button.set_primary_color(active_tab_primary)
			if !stay: _navigate_notifications()
		Navigation_states.SOCIAL:
			social_button.set_primary_color(active_tab_primary)
			if !stay: _navigate_social()
		Navigation_states.STATS:
			stats_button.set_primary_color(active_tab_primary)
			if !stay: _navigate_stats()
		Navigation_states.SETTINGS:
			settings_button.set_primary_color(active_tab_primary)
			if !stay: _navigate_settings()
		_:
			pass

func _navigate_home(): 
	if GameManager == null or GameManager.scene_manager == null: return
	GameManager.scene_manager.go_home()
	
func _navigate_notifications(): 
	_navigate("notifications_scene")

func _navigate_social(): 
	_navigate("social_scene")
	
func _navigate_stats(): 
	_navigate("stats_scene")

func _navigate_settings(): 
	_navigate("settings_scene")

func _navigate(scene):
	if GameManager == null or GameManager.scene_manager == null: return
	GameManager.scene_manager.push_scene(scene, {},
	 TransitionFactory.MoveOut() if last_navigation_state <= navigation_state else TransitionFactory.MoveBack())


