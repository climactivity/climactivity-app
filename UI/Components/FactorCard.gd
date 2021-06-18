extends Control
 
var infobyte setget set_infobyte

func _ready():
	_show_infobyte()
#
#func _input(event):
#	print(event)
#	if event is InputEventMouseButton and event.pressed and get_rect().has_point(event.position):
#		if infobyte != null:
#			GameManager.scene_manager.push_scene("res://Scenes/QuizScene.tscn", {"quiz": infobyte})
func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if infobyte != null:
			GameManager.scene_manager.push_scene("res://Scenes/QuizScene.tscn", {"quiz": infobyte})


func set_infobyte(_infobyte):
	infobyte = _infobyte
	_show_infobyte()
	
func _show_infobyte(): 
	if $CySidePanel == null or infobyte == null: return
	$CySidePanel.set_heading(infobyte.name)
	$CySidePanel/MarginContainer/Label.text = infobyte.frontmatter
	if InfobyteService.is_completed(infobyte._id):
		$CySidePanel.set_heading(infobyte.name + "✔")

func _on_CySidePanel_gui_input(event):
	print(event)
	if event is InputEventMouseButton and event.pressed:
		if infobyte != null:
			GameManager.scene_manager.push_scene("res://Scenes/QuizScene.tscn", {"quiz": infobyte})

func update():
	_show_infobyte()
