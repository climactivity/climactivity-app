extends Panel

var _sector_data = preload("res://ForestScene3d/Tents/SectorData.gd").new().sector_data
var sector_data = null
var loading = true
var bp_aspect_card = preload("res://UI/ListEntry.tscn")
var navigation_data = {}
var aspect_resources = []

var gradient = null

onready var req = $HTTPRequest
onready var aspect_list = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/AspectList"

func _ready(): 

	material = material.duplicate(true)
	gradient = material.get_shader_param("gradient")
	render_resources() 

func load_from_cache(): 
	if Api.is_cache_ready(): 
		_load_from_cache()
	else:
		Api.connect("cache_ready", self, "_load_from_cache")

func _load_from_cache(): 
	if !navigation_data.has("sector"):
		Logger.error("Bigpoint Scene not initialized!", self)
		return
	aspect_resources = Api.get_aspect_data_for_sector(navigation_data.sector)
	Logger.print("Loaded bigpoint scene for %s, loaded %d aspects" % [navigation_data.sector, aspect_resources.size()], self)
	loading = false
	sector_data = _sector_data[navigation_data.sector]
	render_resources()

func receive_navigation(new_navigation_data): 
	navigation_data = new_navigation_data
	load_from_cache()


func render_resources():
	if loading: return
	if aspect_list == null: return
	Util.clear(aspect_list)
	for aspect in aspect_resources: 
		var aspect_card = bp_aspect_card.instance()
		aspect_list.add_child(aspect_card)

		aspect_card.set_content_text(aspect.title)
		if aspect.icon != null: 
			aspect_card.set_icon(aspect.icon)
		else: 
			aspect_card.set_icon(sector_data["sector_logo"])
		aspect_card.set_navigation_target("res://Scenes/AspectScene.tscn")
		aspect_card.set_navigation_payload({"aspect": aspect})
		aspect_card.set_accent_color(sector_data["sector_color"])		
		
	$HeaderContainer/Header.update_header(sector_data["sector_title"], sector_data["sector_logo"], sector_data["sector_color"])
	if gradient != null:
		gradient.gradient.set_color(0, sector_data["sector_color"])
		material.set_shader_param("gradient", gradient)
	$"ContentContainer/Content/HeaderBG".self_modulate = sector_data["sector_color"]
	$"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/AspectList".call_deferred("do_the_thing")
