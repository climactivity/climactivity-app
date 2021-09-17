tool
extends Control


onready var tween = $Tween
func _ready():
	tween.interpolate_property(self, "self_modulate", Color("ffd700"), Color("56ff00"), 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	tween.repeat


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
