extends HBoxContainer

export (NodePath) var target
export (int) var offset = 200

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button1_pressed():
	_scroll_to("ContentMain/TrackingPreview")

func _on_Button2_pressed():
	_scroll_to("ContentMain/InfoGraph")


func _on_Button3_pressed():
	_scroll_to("ContentMain/Aufgaben")

func _scroll_to(path):
	get_node(target).scroll_to_child(path, offset)
