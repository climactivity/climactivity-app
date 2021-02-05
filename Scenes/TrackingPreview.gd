extends VBoxContainer

onready var shop_button_container = $shop_button_container

func show_shop_button():
	Logger.print("new seedling available", self)
