extends SceneBase

func _ready():
	._ready()
	header.update_header( tr('about'), null ,Color("#696968"))
	GameManager.overlay.show_available_tutorial("Intro") # looks janky with main menu
	GameManager.overlay.hide_available_tutorial()

func _on_NavPrivacyNotice_pressed():
	OS.shell_open("https://climactivity.de/datenschutzerklaerung/")
