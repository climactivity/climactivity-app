extends Sprite3D

signal clicked

export var grab_attention = false setget set_grab_attention
export (PackedScene) var widget setget set_widget
var widget_instance

onready var ui_panel = $"Viewport/GUI"

func _ready():
	var viewport_texture = $Viewport.get_texture()
	texture = viewport_texture
	update() 

func set_grab_attention(_att): 
	grab_attention = _att
	update()

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton: 
		if event.pressed:
			emit_signal("clicked")


func set_widget(_widget): 
	widget = _widget
#	widget_instance = widget.instance()
	update()

func get_widget_instance():
	return widget_instance

func update():
	if ui_panel == null or $Viewport == null: return 
	if widget != null: 
		if widget_instance == null: 
			widget_instance = widget.instance()
		Util.clear(ui_panel) 
		if widget_instance.get_parent():
			widget_instance.get_parent().remove_child(widget_instance)
		ui_panel.add_child(widget_instance)

	if $AnimationPlayer != null: 
		if grab_attention:
			$AnimationPlayer.play("Attention")
		elif $AnimationPlayer.current_animation == "Attention":
			$AnimationPlayer.stop(true)
	


