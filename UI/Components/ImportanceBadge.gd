extends Control

export (PackedScene) var badge 
export (int,1,5) var level = 1 setget set_level

onready var container = $Control/HBoxContainer
onready var positioner = $Control
func _ready(): 
	update() 
	
func update():
	if !badge or !container or !positioner:
		return
	Util.clear(container)
	for i in range(0,level):
		container.add_child(badge.instance())
	positioner.rect_position = Vector2(-(33.0 + 4 * 66.0)/1.5, positioner.rect_position.y)

func set_level(_l): 
	level = _l 
	update()
