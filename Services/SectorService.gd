extends Node
var sector_data = preload("res://ForestScene3d/Tents/SectorData.gd").new().sector_data

func get_sector_names(): 
	var names = []
	for sector in sector_data.keys(): 
		names.append(sector_data[sector].sector)
	return names

func get_aspects_per_sector():
	var _sectors = get_sector_names()
	var sectors = {}
	for sector_name in _sectors: 
		sectors[sector_name] = AspectTrackingService.get_tracked_aspects_for_sector(sector_name)
	return sectors

func get_title_for_name(name):
	return sector_data[name].sector_title

func get_sector_data(sector_name):
	return sector_data[sector_name] if sector_data.has(sector_name) else null
