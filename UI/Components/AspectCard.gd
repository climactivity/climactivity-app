extends Control

export(Resource) var aspect_resource setget set_aspect
export (PackedScene) var badge

onready var list_entry = $ListEntry

func _ready():
	update()
	
func set_aspect(new_aspect_resource): 
	aspect_resource = new_aspect_resource
	update()

func update():
	if list_entry != null and aspect_resource != null:
		var sector = SectorService.get_sector_data(aspect_resource.bigpoint)
		if aspect_resource.icon != null: 
			list_entry.set_icon(aspect_resource.icon)
		else: 
			list_entry.set_icon(sector["sector_logo"])
		list_entry.set_navigation_target("res://Scenes/AspectScene.tscn")
		list_entry.set_navigation_payload({"aspect": aspect_resource})
		list_entry.set_accent_color(sector["sector_color"])
		if badge:
			badge = badge.instance()
			match aspect_resource.type:
				'tree': 
					badge.level = 4
					list_entry.set_is_important(true)
				'bush':
					badge.level = 2
				_:
					badge.level = 1
			list_entry.set_attention_grabber(badge)
			list_entry.set_show_attention_grabber(true)
			print("hey ~~~~~")
func _on_enter_button_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/AspectScene.tscn", {"aspect": aspect_resource})

func play_enter():
	list_entry.play_enter()

func _on_MarginContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT: 
			_on_enter_button_pressed()
