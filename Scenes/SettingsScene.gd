extends SceneBase


func _ready():
	._ready()
	header.update_header( tr('about'), null ,Color("#696968"))
	GameManager.overlay.show_available_tutorial("Intro") # looks janky with main menu
	GameManager.overlay.hide_available_tutorial()


