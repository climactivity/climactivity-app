extends Panel


onready var header = $VBoxContainer/Header
onready var tracking_settings = $"VBoxContainer/Content/MarginContainer/ScrollContainer/VBoxContainer/TrackingSettings"
onready var info_graph = $"VBoxContainer/Content/MarginContainer/ScrollContainer/VBoxContainer/InfoGraph"
onready var quests = $"VBoxContainer/Content/MarginContainer/ScrollContainer/VBoxContainer/Aufgaben"

var aspect_data

func _ready():
	if (aspect_data == null): return
	tracking_settings.set_tracking_data(aspect_data["localizedTrackingData"])

func receive_navigation(navigation_data): 
	print(navigation_data)
	aspect_data = navigation_data["aspect"]
	if tracking_settings != null: tracking_settings.set_tracking_data(aspect_data["localizedTrackingData"])

