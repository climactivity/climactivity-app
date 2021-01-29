extends Panel

signal commit_option(option, aspect)

onready var header = $VBoxContainer/Header
onready var tracking_settings = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/TrackingSettings"
onready var info_graph = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/InfoGraph"
onready var quests = $"VBoxContainer/Content/MarginContainer/ScrollContainer/Control/Aufgaben"

export (Resource) var aspect_data

func _ready():
	tracking_settings.connect("emit_option", self, "commit_option")
	connect("commit_option", AspectTrackingService, "commit_tracking_level")
	if (aspect_data == null): return
	tracking_settings.set_tracking_data(aspect_data["localizedTrackingData"])
	tracking_settings.set_title(aspect_data.title)


	
func receive_navigation(navigation_data): 
	print(navigation_data)
	aspect_data = navigation_data["aspect"]
	header.update_header(aspect_data["title"])
	if tracking_settings != null:
		tracking_settings.set_tracking_data(aspect_data.tracking)
		tracking_settings.set_title(aspect_data.title)

func commit_option(option):
	print("ping") 
	emit_signal("commit_option", option, aspect_data)
