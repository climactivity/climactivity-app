tool
extends Control

var paragraph_holder = preload("res://UI/Components/infobits/paragraph_holder.tscn")
var list_holder = preload("res://UI/Components/infobits/list_holder.tscn")
var _hr = preload("res://UI/Components/infobits/HorizontalRule.tscn")
var citations_box = preload("res://UI/Components/infobits/CitationsBox.tscn")
var image_holder = preload("res://UI/Components/infobits/RemoteImage.tscn")
export (String, MULTILINE) var json_doc setget set_json

var infobit_data = [] setget on_data
var sources_counter = 0
var citations_holder 
var citations_text = ""


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
	if citations_text != "":
		_add_citations()
		
func add_image(image_para): 
	var image = image_holder.instance()
	add_child(image)
	image.call_deferred("on_data", image_para)

func add_source(paragraph, link_to_last): 
	var text = _get_citation_text(paragraph)
	if text == "":
		return null
	if !link_to_last: 
		sources_counter = sources_counter + 1
		citations_text += "[%d]: %s \n" % [sources_counter, text]
		return sources_counter 
	else: 
		citations_text.rstrip("\n")
		citations_text += text
		return null

func _get_citation_text(paragraph_dict): 
	var paragraph : String = paragraph_dict.text
	paragraph = paragraph.rstrip("]")
	paragraph = paragraph.lstrip("[")
	if paragraph_dict.has("marks"):
			for mark in paragraph_dict["marks"]:
				match mark["type"]:
					"strong":
						paragraph = "[b]" + paragraph +  "[/b]"
					"em":
						paragraph = "[i]" + paragraph +  "[/i]"
					"link":
						var href = mark["attrs"]["href"]
						paragraph = ("[color=#1a0dab][url=%s]" % href) + paragraph + "[/url][/color]"
					"code":
						print("Citations can't have sources!")
					_: 
						print("Unkown mark type: " + mark["type"])
	return paragraph

func _add_citations(): 
	add_child(_hr.instance())
	var citations = citations_box.instance()
	citations.bbcode_text = citations_text
	add_child(citations)	
	citations.connect("meta_clicked", self, "open_link")
	
func open_link(meta): 
	Util.open_link(meta)
