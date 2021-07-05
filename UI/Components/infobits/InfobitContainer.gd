tool
extends Control

var paragraph_holder = preload("res://UI/Components/infobits/paragraph_holder.tscn")
var list_holder = preload("res://UI/Components/infobits/list_holder.tscn")
var _hr = preload("res://UI/Components/infobits/HorizontalRule.tscn")
var image_holder = preload("res://UI/Components/infobits/RemoteImage.tscn")
export (String, MULTILINE) var json_doc setget set_json

var infobit_data = [] setget on_data

func set_json(doc): 
	json_doc = doc
	if json_doc == "":
		Util.clear(self)
		return
	var dict = JSON.parse(json_doc)
	if(dict.error): 
		print("json parse error %s" % dict.error)
	else:
		on_data(dict.result)

func on_data(new_data):
	infobit_data = new_data
	Util.clear(self)
	for infobit_fragment in infobit_data:
		match infobit_fragment.type:
			"paragraph":
				if !infobit_fragment.has("content"): 
					continue
				var new_holder = paragraph_holder.instance()
				add_child(new_holder)
				new_holder.on_data(infobit_fragment.content)
			"horizontal_rule":
				var hr = _hr.instance()
				add_child(hr)
			"bullet_list":
				var new_holder = list_holder.instance()
				add_child(new_holder)
				new_holder.numbered = false
				new_holder.on_data(infobit_fragment.content)
			"ordered_list":
				var new_holder = list_holder.instance()
				new_holder.numbered = true
				add_child(new_holder)
				new_holder.on_data(infobit_fragment.content)
			_: 
				print("Paragraph type %s not supported!" % infobit_fragment.type)

func add_image(image_para): 
	var image = image_holder.instance()
	add_child(image)
	image.on_data(image_para)
