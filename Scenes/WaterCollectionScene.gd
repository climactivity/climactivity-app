extends SceneBase

var bp_sector_entry = preload("res://UI/Components/SectorHolder.tscn")

onready var cloud_preview = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/CloudHolder/HBoxContainer/CloudPreview"
onready var percent_collected_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/CloudHolder/HBoxContainer/MarginContainer/VBoxContainer/Label"
onready var sector_list = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/SectorHolders"

var fill_state setget set_fill_state
var _sector_data
var data = {}


var num_sectors = 0.0
var num_collected = 0.0

func _ready(): 
	_sector_data = SectorService.get_aspects_per_sector()
	set_screen_title("Tracking")
	set_accent_color(Color('#64A6E2'))
	ready = true
	update()
		 
func update():
	if !ready:
		return

	Util.clear(sector_list)
	for sector in SectorService.get_sector_names():
		var sector_entry = bp_sector_entry.instance()
		sector_list.add_child(sector_entry)
		sector_entry.set_sector_name(sector)
#		sector_entry.set_title(SectorService.get_title_for_name(sector))
#		sector_entry.set_aspects(_sector_data[sector])
		num_sectors += 1.0
		sector_entry.connect("collect", self, "_update_total_water_collected")

func _update_total_water_collected():
	num_collected += 1.0
	set_fill_state(num_collected/num_sectors)

func receive_navigation(navigation_data):
	update()

func set_fill_state(new_state): 
	print("set fill state: ", new_state)
	fill_state = new_state
	material.set("shader_param/fill_state", fill_state)
#	if $Droplet == null: return
#	$Droplet.visible = fill_state > 0.0
