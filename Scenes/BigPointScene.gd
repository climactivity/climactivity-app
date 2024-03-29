extends SceneBase

var _sector_data = preload("res://ForestScene3d/Tents/SectorData.gd").new().sector_data
var sector_data = null
var loading = true
var bp_aspect_card = preload("res://UI/ListEntry.tscn")
var navigation_data = {}
var aspect_resources = []

onready var req = $HTTPRequest
onready var aspect_list = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/AspectList"
onready var kiko_hint = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/AspectList/kiko_avatar - placeholder"
#func _fetch_data(param = null): 
#	if param != null: 
#		Api.getEndpoint("aspect_for_sector",req, [param], true)
#	else: 
#		Api.getEndpoint("aspect_for_sector", req, [], true)

export var badge = preload("res://UI/Components/ImportanceBadge.tscn")

func _ready(): 
	material = material.duplicate(true)
	gradient = material.get_shader_param("gradient")
	render_resources() 
	kiko_hint.play_enter()
	
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
#	if navigation_data.has("sector"): 
#		_fetch_data(navigation_data["sector"])
#	else: 
#		_fetch_data()

func _restored():
	load_from_cache()

func render_resources():
	if loading: return
	if aspect_list == null: return
	Util.clear(aspect_list)
	
#	if aspect_resources.size() == 0: 
	
	aspect_resources.sort_custom(self, "custom_sort_aspects" )
	
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
		aspect_card.is_start_hidden(true)
		
		
		aspect_card.set_use_cirular_progress(true)
		aspect_card.set_is_show_progress(true)
		aspect_card.set_progress(AspectTrackingService.get_aspect_completion(aspect))
		
		
		if badge:
			var badge_inst = badge.instance()
			match aspect.type:
				'tree': 
					badge_inst.level = 4
					aspect_card.set_is_important(true)
				'bush':
					badge_inst.level = 2
				_:
					badge_inst.level = 1
			aspect_card.set_attention_grabber(badge_inst)
			aspect_card.set_show_attention_grabber(true)
	$HeaderContainer/Header.update_header(sector_data["sector_title"], sector_data["sector_logo"], sector_data["sector_color"])
	if gradient != null:
		gradient.gradient.set_color(0, sector_data["sector_color"])
		material.set_shader_param("gradient", gradient)
	$"ContentContainer/Content/HeaderBG".self_modulate = sector_data["sector_color"]
	kiko_hint.set_text(sector_data["sector_hint"])
	$ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/AspectList/Stagger.play_enter()


func custom_sort_aspects(a, b): 
	var a_weight = _get_type_weight(a.type)
	var b_weight = _get_type_weight(b.type)
	return a_weight > b_weight
	
func _get_type_weight(aspect_type): 
	match aspect_type:
		'tree': 
			return 4
		'bush':
			return 2
		_:
			return 1
