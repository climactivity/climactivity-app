extends RichTextLabel


export (String, MULTILINE) var template_str

func _ready():
	bbcode_text = template_str % Engine.get_license_text()
