extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if !OS.is_debug_build() or OS.get_name() in [ "Android", "iOS", "HTML5"]:
		queue_free()
