extends PanelContainer

export(Resource) var aspect_resource setget set_aspect

var title = "NO_DATA"
onready var label = $MarginContainer/HBoxContainer/Label

func _ready():
	label.text = title

func set_aspect(new_aspect_resource): 
	aspect_resource = new_aspect_resource
	title = aspect_resource.title
	if label!= null: label.text = title


func _on_enter_button_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/AspectScene.tscn", {"aspect": aspect_resource})
