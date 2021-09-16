extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.margin_top -= OS.get_window_safe_area().position.y/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
