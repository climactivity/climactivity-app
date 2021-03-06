tool extends RichTextLabel

export var data = [] setget on_data

# handle clicks un urls etc
func _ready():
	connect("meta_clicked", self, "open_link")

func open_link(meta): 
	print(meta)
	OS.shell_open(meta)

#"""TODO generate bbcode from parsed json dict
func _parse_data_object(data) -> String: 
	var text = ""
	for paragraph_dict in data: 
		var paragraph = ""
		if (paragraph_dict.type == "text"): 
			paragraph = paragraph_dict.text 
		elif (paragraph_dict.type == "hard_break"): 
			paragraph = "\n"
		elif (paragraph_dict.type == "image"):
			get_parent().add_image(paragraph_dict)
		else: 
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
						paragraph = ("[color=#1a0dab][url=%s]" % href) + paragraph + "[/url][/color]"
					_: 
						print("Unkown mark type: " + mark["type"], self)
		text = text + paragraph 
	return text + "\n"

func on_data(new_data):
	data = new_data
	var final_text = _parse_data_object(data)
	self.bbcode_text = final_text

