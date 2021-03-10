extends Node

var aspect_data
var ready = false
var templates = []
var bp_entity_card = preload("res://UI/Components/SelectEntityCard.tscn")

#	$HeaderContainer/Header.screen_label = "Tracking"
#	$HeaderContainer/Header.set_color(Color('#64A6E2'))
onready var header = $HeaderContainer/Header
onready var card_holder = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/ScrollContainer/GridContainer"
onready var coin_displayer = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/coin_display"

func _ready(): 
	ready = true
	if aspect_data != null: show_data()

func receive_navigation(navigation_data): 
	if navigation_data.has("aspect"):
		aspect_data = navigation_data["aspect"]
		if ready:
			header.update_header(aspect_data["title"])
			show_data()
	
func show_data(): 
	if ready: 
		templates = TreeTemplateFactory.templates_in_sector(aspect_data.bigpoint)
		for node in card_holder.get_children(): 
			node.free()
		for template in templates: 
			var card = bp_entity_card.instance()
			card.set_entity(template)
			card.set_aspect(aspect_data)
			card_holder.add_child(card)
