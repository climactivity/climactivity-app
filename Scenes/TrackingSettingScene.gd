extends SceneBase

onready var tracking_settings = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/TrackingSettings"
export (Resource) var aspect_data

func _ready():
	#tracking_settings.connect("emit_option", self, "commit_option")
	#connect("commit_option", AspectTrackingService, "commit_tracking_level")
	if (aspect_data == null): return
	update()
	yield(get_tree().create_timer(1.0), "timeout")
	
func receive_navigation(navigation_data): 
	#print(navigation_data)
	aspect_data = navigation_data["aspect"]
	update()

func update():
	
	if tracking_settings != null:
		tracking_settings.set_tracking_data(aspect_data.tracking, aspect_data)
		tracking_settings.set_title(aspect_data.title)
	
	var sector = SectorService.get_sector_data(aspect_data.bigpoint)
	
	set_accent_color(sector["sector_color"])
	set_header_icon(aspect_data.icon if aspect_data.icon !=null else sector["sector_logo"])
	set_screen_title(aspect_data["title"])
