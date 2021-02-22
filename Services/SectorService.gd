extends Node
var sector_data = preload("res://ForestScene3d/Tents/SectorData.gd").new().sector_data

func get_sector_names(): 
	return sector_data.keys()
