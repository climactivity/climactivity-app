# tile_object_plugin.gd
tool
extends EditorPlugin
const TileObject = preload("res://addons/tile_object/tile_object.gd")
var _current = null
func _enter_tree():
	add_custom_type("TileObject", "Node2D", TileObject, preload("res://addons/tile_object/tile_object_icon.png"))
func _exit_tree():
	remove_custom_type("TileObject")
func handles(object):
	return object is TileObject
func edit(object):
	if _current != object:
		_current = object
func make_visible(visible):
	if not visible:
		_current = null
func clear():
	_current = null
func forward_canvas_gui_input(event):
	if _current != null:
		if (event is InputEventMouseButton) and (not event.pressed):
			assert(_current is TileObject)
			assert(_current.get_parent() is TileMap)
			
			var origin_tile = _current.get_parent().world_to_map(_current.position) # _current.position / _current.tile_size
			_current.tile_pos = Vector2(round(origin_tile.x), round(origin_tile.y))
			_current.update()
			print(_current.tile_pos)
