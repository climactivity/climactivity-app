tool
extends Node2D


#class_name TilePlaceableObject 

signal placing(Node2D)

# Base size of tiles to be placed on (in px)
export(Vector2) var tile_size = Vector2(120,104) setget set_tile_size

# How many tiles are covered by this object
export(Vector2) var tile_dimensions = Vector2(1,1) setget set_tile_dimensions

# Position of object on tile, rel to top left coord
export(Vector2) var tile_offset = Vector2.ZERO setget set_tile_offset

export(Vector2) var tile_pos = Vector2(0,0) setget set_tile_pos
export var fixed = false

#func _ready():
#	if get_parent() is TileMap:
#		set_tile_size(get_parent().cell_size)
#	var tile = position / tile_size
#	set_tile_pos(Vector2(round(tile.x), round(tile.y)))

func _ready():
	
	if get_parent() is TileMap:
		var parent: TileMap = get_parent()
		set_tile_size(parent.cell_size)
		#print(parent.world_to_map(position))
		#set_tile_pos(parent.world_to_map(position + tile_offset))

	_update_position()

func update(): 
	_update_position()

func _update_position():
	if get_parent() is TileMap:
		position = get_parent().map_to_world(tile_pos) + tile_offset
	#else:
	#	position = (tile_pos * tile_size) #+ tile_offset

func _draw():
	if Engine.editor_hint:
		var rect = Rect2(Vector2() - tile_offset, tile_dimensions * tile_size)
		draw_rect(rect, Color(1, 1, 1), false)

func set_tile_size(value: Vector2) -> void:
	tile_size = value 
	_update_position()
	if Engine.editor_hint:
		update()
		
func set_tile_dimensions(value: Vector2) -> void:
	tile_dimensions = value 
#	_update_position()
	if Engine.editor_hint:
		update()

func set_tile_pos(value: Vector2) -> void:
	if fixed: 
		return
	tile_pos = value 
	_update_position()
	if Engine.editor_hint:
		update()
		
func set_tile_offset(value: Vector2) -> void:
	tile_offset = value
	_update_position()
	if Engine.editor_hint:
		update()
