tool
extends RichTextLabel

export (String, MULTILINE) var template_str

func _ready():
	bbcode_text = template_str % [ProjectSettings.get_setting("application/config/version"), Engine.get_version_info().string]
