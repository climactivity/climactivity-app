tool
extends RichTextLabel

export var data = [] setget on_data
enum ListType {NUMBERED, UNORDERED}
export var numbered = false
# handle clicks un urls etc
func _ready():
	connect("meta_clicked", self, "open_link")

func open_link(meta): 
	Util.open_link(meta)

#"""TODO generate bbcode from parsed json dict
func _parse_data_object(data, depth = 0, _numbered = false, running_number = 0, lf = true ) -> String: 
	var text = ""
	for paragraph_dict in data: 
		var paragraph = ""

		match paragraph_dict.type: 
			"paragraph": 
				text = _parse_data_object(paragraph_dict.content, depth, _numbered, 0, false)
			"text": 
#				print(paragraph_dict.text)
				paragraph = paragraph_dict.text 
			"hard_break":
				paragraph = "\n"
			"image":
				get_parent().add_image(paragraph_dict)
			"ordered_list":
				paragraph = paragraph + _parse_data_object(paragraph_dict.content, depth + 1, true, 0, false)
			"bullet_list":
				paragraph =  paragraph + _parse_data_object(paragraph_dict.content, depth + 1, false, 0, false)
			"list_item": 
				running_number += 1
				var inner_text =  paragraph + _parse_data_object(paragraph_dict.content, depth + 1, _numbered, 0, false)
				var seperator = "- " if !_numbered else ("%d. " % running_number)
				paragraph = paragraph + "[indent]" + seperator + inner_text + "[/indent] \n"
			_:
				print("Unkown type: " + paragraph_dict.type, self)

		if paragraph_dict.has("marks"):
			for mark in paragraph_dict["marks"]:
				match mark["type"]:
					"strong":
						paragraph = "[b]" + paragraph +  "[/b]"
					"em":
						paragraph = "[i]" + paragraph +  "[/i]"
					"link":
						var href = mark["attrs"]["href"]
						paragraph = ("[url=%s]" % href) + paragraph + "[/url]"
					_: 
						print("Unkown mark type: " + mark["type"], self)
		text = text + paragraph 
	return text + ("\n" if lf else "") 

func on_data(new_data):
	data = new_data
	var final_text = _parse_data_object(data, 0, numbered)
	self.bbcode_text = final_text

