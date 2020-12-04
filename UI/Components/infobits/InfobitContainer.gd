extends Control


var paragraph_holder = preload("res://UI/Components/infobits/paragraph_holder.tscn")
var infobit_data = [] setget on_data


func on_data(new_data):
	infobit_data = new_data
	for infobit_fragment in infobit_data:
		if(infobit_fragment.type == "paragraph"):
			var new_holder = paragraph_holder.instance()
			new_holder.on_data(infobit_fragment.content)
			add_child(new_holder)
