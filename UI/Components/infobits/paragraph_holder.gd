extends RichTextLabel

export var data = [] setget on_data


#"""TODO
func _parse_data_object(data) -> String: 
	var text = ""
	for paragraph_dict in data: 
		if (paragraph_dict.type == "text"): 
			text = text + paragraph_dict.text 
		elif (paragraph_dict.type == "hard_break"): 
			text = text + "\n"
		else: 
			Logger.print("Unkown type: " + paragraph_dict.type, self)
	return text

func on_data(new_data):
	data = new_data
	var final_text = _parse_data_object(data)
	self.bbcode_text = final_text

