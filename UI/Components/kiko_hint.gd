tool
extends Control

export var text = "" setget set_text 

onready var label = $"SpeechBubbleHolder/MarginContainer/DialogLine"

func _ready():
	label.text = text

func set_text(new_text):
	text = str(new_text)
	if label != null: 
		label.bbcode_text = "[center]" + text + "[/center]"
