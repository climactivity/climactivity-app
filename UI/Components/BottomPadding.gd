extends HSeparator


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var base_padding = 244
# Called when the node enters the scene tree for the first time.
func _ready():
	self.set("custom_constants/separation", self.get("custom_constants/separation") + OS.get_window_safe_area().position.y/2 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
