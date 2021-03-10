tool
extends Sprite3D

export (float) var _unit_factor = 1.0 setget set_unit_factor

onready var ui_panel = $SpatialUIPanel
var ui_initial_transform 
var tex_size = Vector2(0.0,0)

func _ready():

	_offset_and_scale()
	if ui_panel == null: return
	ui_initial_transform = ui_panel.transform
	if GameManager != null and GameManager.camera != null: 
		GameManager.camera.connect("camera_rotated", self, "_layout_ui")
		_layout_ui(GameManager.camera.rotation.x)
		
func set_texture(new_texture): 
	texture = new_texture
	_offset_and_scale()

func set_unit_factor(new_factor):
	_unit_factor = new_factor
	_offset_and_scale()
	
func apply_scaling_factor(factor):
	_unit_factor *= factor
	_offset_and_scale()
	
func _offset_and_scale():
	tex_size = texture.get_size()
	pixel_size = _unit_factor / texture.get_size().y  
	offset = Vector2( -texture.get_size().x / 2.0,0.0)
	#print("_offset_and_scale %s %s" % [str(pixel_size), str(offset)])

func layout_ui():
	_layout_ui(GameManager.camera.rotation.x)

func _layout_ui(phi):
	if ui_panel == null: return
	ui_panel.transform.origin = ui_initial_transform.origin + Vector3(0.0, tex_size.y * pixel_size, 0.0)
	ui_panel.transform.origin = ui_panel.transform.origin.rotated(Vector3.RIGHT, phi)
	ui_panel.rotation.x = phi # - deg2rad(-27.5)
