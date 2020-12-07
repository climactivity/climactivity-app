extends Control

signal finished
signal at_start
signal anim_finished
signal go_back
export var infobits_data = [] setget set_infobits_data

var infobits = [] 
export var max_index = 0
export var current_index = -1
var current_infobit
const infobit_container_factory = preload("res://UI/Components/infobits/InfobitContainer.tscn")

onready var infobit = $"InfoBit"
onready var old_infobit = $"Old_Infobit"

onready var infobit_holder = $"InfoBit/MarginContainer"
onready var old_infobit_holder = $"Old_Infobit/MarginContainer"

func _ready(): 
	pass

func next() -> void:
	current_index = current_index + 1
	update_current_infobit("finished", "forward")

func prev() -> void: 
	current_index = max(current_index -1 , -1)
	if(current_index == -1):
		update_current_infobit("go_back")
	else:
		update_current_infobit("at_start", "backward")

func update_current_infobit(signal_to_emit: String, anim_to_play = "") -> void:
	if infobits.size() > current_index && current_index > -1:
		current_infobit = infobits[current_index]
		for child in old_infobit_holder.get_children():
			old_infobit_holder.remove_child(child)
		for child in infobit_holder.get_children():
			infobit_holder.remove_child(child)
			old_infobit_holder.add_child(child)
		infobit_holder.add_child(current_infobit)
		if(anim_to_play != ""): $AnimationPlayer.play(anim_to_play)
	else:
		emit_signal(signal_to_emit)
		current_index = min(current_index, infobits.size() - 1)

func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("anim_finished")

func _parse_infobit_data(): 
	for infobit_dto in infobits_data:
		var infobit_container = infobit_container_factory.instance()
		infobit_container.on_data(infobit_dto.doc.content)
		infobits.push_back(infobit_container)
	max_index = infobits.size() - 1

func set_infobits_data(new_data) -> void:
	infobits_data = new_data
	infobits = []
	current_index = -1
	_parse_infobit_data()



