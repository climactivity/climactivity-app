extends Spatial

signal clicked

export (PackedScene) var widget setget set_widget
var widget_instance
onready var ui_panel = $"Viewport/GUI"

func _ready():
	update() 

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton: 
		if event.pressed:
			emit_signal("clicked")


func set_widget(_widget): 
	widget = _widget
	widget_instance = widget.instance()
	update()

func get_widget_instance():
	return widget_instance

func update():
	if ui_panel == null: return 
	if widget_instance != null:  
		Util.clear(ui_panel) 
		widget_instance.get_parent().remove_child(widget_instance)
		ui_panel.add_child(widget_instance)

