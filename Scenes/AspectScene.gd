extends SceneBase

signal commit_option(option, aspect)

#onready var header = $"HeaderContainer/Header"

onready var info_graph = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/InfoGraph"
onready var quests = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/Aufgaben"

onready var tracking_question = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TrackingPreview/TrackingQuestion"
onready var tracking_options_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TrackingPreview/CySidePanel/HBoxContainer/MarginContainer/VBoxContainer/CurrentTrackingSetting/Label"
onready var tracking_level =  $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TrackingPreview/CySidePanel/HBoxContainer/MarginContainer/VBoxContainer/CurrentTrackingSetting/OptionValueLabel"
onready var go_to_tracking_button = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TrackingPreview/MarginContainer/PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/Button"
onready var tracking_preview = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TrackingPreview"
onready var tracking_reward = $ "ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TrackingPreview/CySidePanel/HBoxContainer/MarginContainer/VBoxContainer/CurrentTrackingSetting2/OptionRewardLabel"
onready var factor_holder = $ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/InfoGraph/VBoxContainer/MarginContainer2/FactorHolder
onready var quest_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/Aufgaben"
export (Resource) var aspect_data

#var ready = false
var should_animate = false
func _ready():
	#tracking_settings.connect("emit_option", self, "commit_option")
	#connect("commit_option", AspectTrackingService, "commit_tracking_level")
	GameManager.scene_manager.connect("current_transition_finished", self, "anim_start")	
	ready = true
	_show_data()

	
func receive_navigation(navigation_data): 
	if navigation_data.has("aspect"):
		aspect_data = navigation_data["aspect"]
	if ready:
		_show_data()

func _show_data(): 
	if (aspect_data == null): return
	var sector = SectorService.get_sector_data(aspect_data.bigpoint)
	
	set_screen_title(aspect_data.title)
	if aspect_data.icon != null: 
		header.set_icon_texture(aspect_data.icon)
	set_accent_color(sector["sector_color"])
	set_header_icon(aspect_data.icon if aspect_data.icon !=null else sector["sector_logo"])
	factor_holder.set_factors(aspect_data.factors, aspect_data)
	quest_holder.load_for_aspect(aspect_data)
	tracking_preview.set_aspect(aspect_data, sector)
#	tracking_question.set_text(aspect_data.tracking.question)
#	tracking_options_label.text = tr("current_tracking_level_label")
#	tracking_level.text = tr("current_tracking_level_unset")
#	var current_tracking_level = AspectTrackingService.get_current_tracking_level(aspect_data)
#	if current_tracking_level == null: return
#	var current_option = aspect_data.get_option_for_level(current_tracking_level.level)
#	if current_option != null:
#		tracking_level.text = current_option.option
#		tracking_reward.set_reward(current_option.reward)
#	if AspectTrackingService.has_seedling_available(aspect_data):
#		should_animate = true
#		#tracking_preview.show_shop_button()

func anim_start(): 
	if should_animate or ProjectSettings.get_setting("debug/settings/game_logic/cheat_seedlings"):# || OS.is_debug_build():
		tracking_preview.show_shop_button(aspect_data)

func _on_Button_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/TrackingSettingScene.tscn", {"aspect": aspect_data})

func _enter_tree():
	if ready:
		_show_data()


func _on_Panel_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/TrackingSettingScene.tscn", {"aspect": aspect_data})
