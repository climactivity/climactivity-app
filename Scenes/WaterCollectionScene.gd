extends Control

var bp_sector_entry = preload("res://UI/Components/SectorHolder.tscn")

onready var cloud_preview = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/CloudHolder/HBoxContainer/CloudPreview"
onready var percent_collected_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/CloudHolder/HBoxContainer/MarginContainer/VBoxContainer/Label"
onready var sector_list = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/SectorHolders"

var fill_state setget set_fill_state
var _sector_data
var data = {}
var ready = false

export var do_render = true 

var num_sectors = 0.0
var num_collected = 0.0

func _ready(): 
	_sector_data = SectorService.get_aspects_per_sector()
	$HeaderContainer/Header.screen_label = "Tracking"
	$HeaderContainer/Header.set_color(Color('#64A6E2'))
	ready = true
	if _sector_data != null and do_render:
		_render()
		 
func _render():
	Util.clear(sector_list)
	for sector in _sector_data.keys():
		var sector_entry = bp_sector_entry.instance()
		sector_list.add_child(sector_entry)
		sector_entry.sector_key = sector
		sector_entry.set_title(SectorService.get_title_for_name(sector))
		sector_entry.set_aspects(_sector_data[sector])
		num_sectors += 1.0
		sector_entry.connect("collect", self, "_update_total_water_collected")

func _update_total_water_collected():
	num_collected += 1.0
	set_fill_state(num_collected/num_sectors)



func set_fill_state(new_state): 
	print("set fill state: ", new_state)
	fill_state = new_state
	material.set("shader_param/fill_state", fill_state)
#	if $Droplet == null: return
#	$Droplet.visible = fill_state > 0.0
