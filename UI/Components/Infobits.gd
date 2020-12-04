extends Control

signal finished

export var infobits_data = [] setget set_infobits_data

var infobits = []
var current_index = -1
var current_infobit
const infobit_container_factory = preload("res://UI/Components/infobits/InfobitContainer.tscn")

onready var infobit_holder = $"InfoBit"

func next():
	current_index = current_index + 1
	if infobits.size() > current_index:
		current_infobit = infobits[current_index]
		for child in infobit_holder.get_children():
			infobit_holder.remove_child(child)
		infobit_holder.add_child(current_infobit)
	else:
		emit_signal("finished")

func _parse_infobit_data(): 
	for infobit_dto in infobits_data:
		var infobit_container = infobit_container_factory.instance()
		infobit_container.on_data(infobit_dto.doc.content)
		infobits.push_back(infobit_container)

func set_infobits_data(new_data):
	infobits_data = new_data
	infobits = []
	current_index = -1
	_parse_infobit_data()
