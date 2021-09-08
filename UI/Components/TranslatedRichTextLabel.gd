extends RichTextLabel

export (String) var translation_key

func _ready():
	bbcode_text = tr(translation_key)
