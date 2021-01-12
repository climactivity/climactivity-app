extends PanelContainer

var aspect_data setget set_aspect
var title = "NO_DATA"
onready var label = $MarginContainer/HBoxContainer/Label

func _ready():
	label.text = title

func set_aspect(new_aspect_data): 
	aspect_data = new_aspect_data
	title = aspect_data["localizedStrings"][0]["strings"]["title"]
	if label!= null: label.text = title


func _on_enter_button_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/AspectScene.tscn", {"aspect": aspect_data})
