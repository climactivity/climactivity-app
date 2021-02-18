extends Control

#override with something more interesting? 

export var sector_color = Color('#5d5d5d')
export var bg_color = Color('#d5d5d5')
export var font_color = Color('#fafafa')

export var sector_key = ""
export var colors = {
	"ernaehrung": {
		"sector_color": Color('#5d5d5d'),
		"bg_color": Color('#d5d5d5'),
		"font_color": Color('#fafafa')
	},
}

export var sector_title = "MISSING_SECTOR_TITLE"

var aspects = [] setget set_aspects
const aspect_card = preload("res://UI/Components/AspectWaterTankCard.tscn")

onready var sector_title_label = $"AspectHolder/SectorHeadingPanel/MarginContainer/SectorHeadingLabel"
onready var aspects_holder = $"VBoxContainer/AspectHolder"

func _init(): 
	if colors.has(sector_key):
		var _colors = colors.get(sector_key)
		sector_color = _colors.sector_color
		bg_color = _colors.bg_color
		font_color= _colors.font_color

func _ready():
	_render_aspects()

func set_aspects(aspects_data):
	aspects = aspects_data
	_render_aspects()
	
func _render_aspects():
	if aspects_holder == null: return
	Util.clear(aspects_holder)
	_sort_aspects()	
	for aspect in aspects:
		var instance = aspect_card.instance()
		instance.set_aspect(aspect)
		aspects_holder.add_child(instance)

func _sort_aspects():
	pass

func _get_total_water_available(): 
	pass

func _get_shortest_remaining_fill_time():
	pass


