tool extends RichTextLabel

export var data = [] setget on_data

# handle clicks un urls etc
func _ready():
	connect("meta_clicked", self, "open_link")

func open_link(meta): 
	Util.open_link(meta)
#"""TODO generate bbcode from parsed json dict
func parse_data_object(data) -> String: 
	var text = ""
	for paragraph_dict in data: 
		var link_to_last = false
		var paragraph = ""
		if (paragraph_dict.type == "text"): 
			paragraph = paragraph_dict.text 
		elif (paragraph_dict.type == "hard_break"): 
			paragraph = "\n"
		elif (paragraph_dict.type == "image"):
			get_parent().add_image(paragraph_dict)
		else: 
			print("Unkown type: " + paragraph_dict.type)
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
						link_to_last = true
					"code":
						var cite_id =  get_parent().add_source(paragraph_dict, link_to_last)
						paragraph = ("[%d]" % cite_id) if cite_id != null else ""
					_: 
						print("Unkown mark type: " + mark["type"])
		text = text + paragraph 
	return text + "\n"

func on_data(new_data):
	data = new_data
	var final_text = parse_data_object(data)
	self.bbcode_text = final_text

