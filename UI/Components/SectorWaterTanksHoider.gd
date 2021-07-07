extends Control

#override with something more interesting? 

export var sector_color = Color('#5d5d5d')
export var bg_color = Color('#d5d5d5')
export var font_color = Color('#fafafa')

signal collect(tracking_data)
signal added_aspect

var sector_name setget set_sector_name
var sector 
var aspects = []
const aspect_card = preload("res://UI/Components/AspectWaterTankCard.tscn")

onready var sector_title_label = $"AspectHolder/SectorHeadingPanel/MarginContainer/SectorHeadingLabel"
onready var aspects_holder = $"AspectHolder/MarginContainer/AspectWaterTankHolder"

func _ready():
	if !sector: return
	update()

func _emit(tracking_data): 
	emit_signal("collect", tracking_data)

func set_sector_name(_sector_name):
	sector_name = _sector_name
	sector = SectorService.get_sector_data(sector_name)
	aspects = AspectTrackingService.get_tracked_aspects_for_sector(sector_name)
	update()
	

#	"ernaehrung": {
#		"sector": "ernaehrung",
#		"sector_title": "Zelt der Ernährung",
#		"sector_logo": preload("res://Assets/Icons/climactivity_H-Icon_Ernaehrung.png"),
#		"sector_color": Color('#97e831')  

func update():
	if !sector: 
		return
	
	sector_title_label.text = sector["sector_title"]
	sector_color = sector["sector_color"]
	bg_color = sector_color.lightened(0.4)
	font_color = sector_color.darkened(0.4)
	self_modulate = bg_color
	if aspects_holder == null: return
	Util.clear(aspects_holder)
	_sort_aspects()
	if aspects.size() == 0: 
		visible = false
	for aspect in aspects:
		var instance = aspect_card.instance()
		instance.set_sector_data(sector)
		instance.set_aspect_data(aspect)
		instance.set_color(sector_color)
		aspects_holder.add_child(instance)
		instance.connect("collect", self, "_emit")
		emit_signal("added_aspect")

func _sort_aspects():
	pass

func _get_total_water_available(): 
	pass

func _get_shortest_remaining_fill_time():
	pass


