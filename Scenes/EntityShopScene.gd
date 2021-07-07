extends SceneBase

var aspect_data : RLocalizedAspectData
var templates = []
var bp_entity_card = preload("res://UI/Components/SelectEntityCard.tscn")

#	$HeaderContainer/Header.screen_label = "Tracking"
#	$HeaderContainer/Header.set_color(Color('#64A6E2'))
onready var card_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/ScrollContainer/GridContainer"
onready var coin_displayer = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/coin_display"

func _ready(): 
	ready = true
	if aspect_data != null: show_data()
#	play_intro()
#
#func play_intro():
#	if Dialogic.get_variable("IntroPlayed") == "false" or Util.debug_dialog():
#		yield(get_tree().create_timer(1.0), "timeout")
#		GameManager.overlay.show_dialog("ShopIntro")
func receive_navigation(navigation_data): 
	if navigation_data.has("aspect"):
		aspect_data = navigation_data["aspect"]
		if ready:

			show_data()
	
func show_data(): 
	if !ready:
		yield(self, "ready")
	print(aspect_data.bigpoint," ",aspect_data.type)
	var sector = SectorService.get_sector_data(aspect_data.bigpoint)
	set_accent_color(sector["sector_color"])
	templates = TreeTemplateFactory.get_available_templates(aspect_data.bigpoint, aspect_data.type)
	for node in card_holder.get_children(): 
		node.queue_free()
	for template in templates: 
		var card = bp_entity_card.instance()
		card.set_entity(template)
		card.set_aspect(aspect_data)
		card_holder.add_child(card)
