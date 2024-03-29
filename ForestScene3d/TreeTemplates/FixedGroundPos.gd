tool
extends Sprite3D

export (float) var _unit_factor = 1.0 setget set_unit_factor
export (float) var scaling_factor = 1.0 setget apply_scaling_factor

export (Vector2) var tex_size_override_if_zero = Vector2(512,512)
var _unit_factor_base
var ui_panel 
var ui_initial_transform 
var tex_size = Vector2(0.0,0)

func _ready():
	_unit_factor_base = _unit_factor
	_offset_and_scale()
	ui_panel = get_node_or_null("UI_Alert_Can_Water")
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
	_unit_factor_base = _unit_factor
	_offset_and_scale()
	
func apply_scaling_factor(factor):
	scaling_factor = factor
	_unit_factor = factor * _unit_factor_base
	_offset_and_scale()
	
func _offset_and_scale():
	tex_size = texture.get_size() if texture != null else Vector2(1.0,1.0)
	if tex_size == Vector2.ZERO:
		tex_size = tex_size_override_if_zero
	pixel_size = _unit_factor / tex_size.y  
	offset = Vector2( -tex_size.x / 2.0,0.0)
	#print("_offset_and_scale %s %s" % [str(pixel_size), str(offset)])

func layout_ui():
	_layout_ui(GameManager.camera.rotation.x)

func _layout_ui(phi):
	if ui_panel == null: return
	ui_panel.transform.origin = ui_initial_transform.origin + Vector3(0.0, tex_size.y * pixel_size, 0.0)
	ui_panel.transform.origin = ui_panel.transform.origin.rotated(Vector3.RIGHT, phi)
	ui_panel.rotation.x = phi # - deg2rad(-27.5)
