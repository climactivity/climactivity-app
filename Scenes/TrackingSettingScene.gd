extends SceneBase

onready var tracking_settings = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/TrackingSettings"
onready var footnotes_container = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/FootNoteContainer"
onready var footnotes_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/FootNoteContainer/FootNoteText"
export (Resource) var aspect_data

func _ready():
	if (aspect_data == null): return
	update()
	yield(get_tree().create_timer(1.0), "timeout")
	
func receive_navigation(navigation_data): 
	#print(navigation_data)
	aspect_data = navigation_data["aspect"]
	update()

	
func _show_seedling_button():
	Logger.print("Check has_seedling_available: %s" % str(aspect_data._id), self)
	yield(get_tree().create_timer(0.2), "timeout")
	if AspectTrackingService.has_seedling_available(aspect_data):
		$AnimationPlayer.play("ShowShopButton")

func update():
	if tracking_settings != null:
		tracking_settings.set_tracking_data(aspect_data.tracking, aspect_data)
		tracking_settings.set_title(aspect_data.title)
	var sector = SectorService.get_sector_data(aspect_data.bigpoint)
	set_accent_color(sector["sector_color"])
	set_header_icon(aspect_data.icon if aspect_data.icon !=null else sector["sector_logo"])
	set_screen_title(aspect_data["title"])
	if aspect_data.tracking.has("footnote"): 
		footnotes_container.visible = true
		footnotes_label.bbcode_text = aspect_data.tracking.footnote
	else: 
		footnotes_container.visible = false

func _on_ShopButton_pressed():
		GameManager.scene_manager.push_scene("res://Scenes/EntityShopScene.tscn", {"aspect": aspect_data})


func _on_TrackingSettings_emit_option(option, aspect):
#	return
	_show_seedling_button()
