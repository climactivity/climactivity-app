extends Control

signal finished
export var infobits_data = [] setget set_infobits_data

var infobits


func _next()

func set_infobits_data(new_data):
	infobits_data = new_data
	print(infobits_data)	
