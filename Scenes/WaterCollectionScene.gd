extends SceneBase

var bp_sector_entry = preload("res://UI/Components/SectorHolder.tscn")

onready var cloud_panel_bg = $"ContentContainer/Content/VBoxContainer2/CloudHolder/Panel"
onready var cloud_preview = $"ContentContainer/Content/VBoxContainer2/CloudHolder/HBoxContainer/MarginContainer2/CloudPreview"
onready var percent_collected_label = $"ContentContainer/Content/VBoxContainer2/CloudHolder/HBoxContainer/MarginContainer/VBoxContainer/Label"
onready var sector_list = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/SectorHolders"
onready var top_seperator = $"ContentContainer/Content/VBoxContainer2/HSeparator"
var fill_state setget set_fill_state
var _sector_data
var data = {}


var num_aspects = 0.0
var num_collected = 0.0

func _ready(): 
	_sector_data = SectorService.get_aspects_per_sector()
	set_screen_title("Tracking")
	set_accent_color(Color('#64A6E2'))
	ready = true
	update()
	connect("align_top", self, "align_cloud")
	connect("header_shadow_alpha", self, "shadow_collection_preview")
	
func shadow_collection_preview(shadow_alpha):
	var stylebox = cloud_panel_bg.get_stylebox("panel")
	stylebox.set("shadow_size", 22.0 * shadow_alpha)
	stylebox.set("shadow_offset", 22.0 * shadow_alpha)
	
func align_cloud(offset): 
	top_seperator.set("custom_constants/seperation", offset)
func update():
	if !ready:
		return

	Util.clear(sector_list)
	num_aspects = 0.0
	num_collected = 0.0
	for sector in SectorService.get_sector_names():
		var sector_entry = bp_sector_entry.instance()
		sector_list.add_child(sector_entry)
		sector_entry.connect("added_aspect", self, "_inc_num_aspects")
		sector_entry.set_sector_name(sector)
#		sector_entry.set_title(SectorService.get_title_for_name(sector))
#		sector_entry.set_aspects(_sector_data[sector])
		sector_entry.connect("collect", self, "_update_total_water_collected")
	$"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/VBoxContainer/SectorHolders/Stagger".play_enter()
func _inc_num_aspects():
	num_aspects += 1.0 
	
func _update_total_water_collected(aspect_data):
	num_collected += 1.0
	set_fill_state(num_collected/num_aspects)

func receive_navigation(navigation_data):
	update()

func set_fill_state(new_state): 
	print("set fill state: ", new_state)
	fill_state = new_state
	cloud_preview.material.set_shader_param("fill_state", fill_state)
	percent_collected_label.text = "%d / %d eingesammelt (%3d %%)" % [num_collected,num_aspects,(100.0 * num_collected/num_aspects)]
	#if $Droplet == null: return
#	$Droplet.visible = fill_state > 0.0
