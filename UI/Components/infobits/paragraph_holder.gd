extends RichTextLabel

export var data = [] setget on_data

func _parse_data_object(data) -> String: 
	return str(data)

func on_data(new_data):
	data = new_data
	var final_text = _parse_data_object(data)
	self.bbcode_text = final_text

