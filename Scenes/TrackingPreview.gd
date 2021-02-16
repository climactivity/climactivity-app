extends VBoxContainer

onready var shop_button_container = $shop_button_container
onready var anim_player = $AnimationPlayer

var aspect_data

func show_shop_button(new_aspect_data):
	Logger.print("new seedling available", self)
	aspect_data = new_aspect_data
	#shop_button_container.visible = true
	anim_player.play("ShowShopButton")

func _on_entity_shop_button_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/EntityShopScene.tscn", {"aspect": aspect_data})

