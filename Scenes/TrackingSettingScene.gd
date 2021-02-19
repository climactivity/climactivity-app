extends Panel

onready var tracking_settings = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/TrackingSettings"
export (Resource) var aspect_data
onready var header = $HeaderContainer/Header
func _ready():
	#tracking_settings.connect("emit_option", self, "commit_option")
	#connect("commit_option", AspectTrackingService, "commit_tracking_level")
	if (aspect_data == null): return
	tracking_settings.set_tracking_data(aspect_data.tracking, aspect_data)
	tracking_settings.set_title(aspect_data.title)


	
func receive_navigation(navigation_data): 
	#print(navigation_data)
	aspect_data = navigation_data["aspect"]
	header.update_header(aspect_data["title"])
	if tracking_settings != null:
		tracking_settings.set_tracking_data(aspect_data.tracking, aspect_data)
		tracking_settings.set_title(aspect_data.title)
