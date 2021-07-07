extends Control

export (PackedScene) var badge 
export (int,1,5) var level = 1

onready var container = $Control/HBoxContainer
onready var positioner = $Control
func _ready():
	if !badge:
		return
	Util.clear(container)
	for i in range(0,level):
		container.add_child(badge.instance())
	positioner.rect_position = Vector2(-(33.0 + 4 * 66.0)/1.5, positioner.rect_position.y)
