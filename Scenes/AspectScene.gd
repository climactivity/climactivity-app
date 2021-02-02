extends Panel

signal commit_option(option, aspect)

onready var header = $VBoxContainer/Header
onready var tracking_settings = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/TrackingSettings"
onready var info_graph = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/InfoGraph"
onready var quests = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/Aufgaben"

onready var tracking_question = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/TrackingPreview/TrackingQuestion"
onready var tracking_options_label = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/TrackingPreview/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/CurrentTrackingSetting/Label"
onready var tracking_level = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/TrackingPreview/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/CurrentTrackingSetting/OptionValueLabel"
onready var go_to_tracking_button = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/TrackingPreview/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/Button"

export (Resource) var aspect_data

var ready = false

func _ready():
	#tracking_settings.connect("emit_option", self, "commit_option")
	#connect("commit_option", AspectTrackingService, "commit_tracking_level")
	ready = true
	_show_data()
	
func receive_navigation(navigation_data): 
	if navigation_data.has("aspect"):
		aspect_data = navigation_data["aspect"]
	header.update_header(aspect_data["title"])
	if ready:
		_show_data()

func _show_data(): 
	if (aspect_data == null): return
	tracking_settings.set_tracking_data(aspect_data.tracking, aspect_data)
	tracking_settings.set_title(aspect_data.title)
	tracking_question.set_text(aspect_data.tracking.question)
	tracking_options_label.text = tr("current_tracking_level_label")
	var current_tracking_level = AspectTrackingService.get_current_tracking_level(aspect_data)
	var current_option = aspect_data.get_option_for_level(current_tracking_level.level)
	if current_option != null:
		tracking_level.text = current_option.option
	else:
		tracking_level.text = tr("current_tracking_level_unset")

func _on_Button_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/TrackingSettingScene.tscn", {"aspect": aspect_data})

func _enter_tree():
	if ready:
		_show_data()
