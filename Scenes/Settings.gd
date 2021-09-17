extends MarginContainer

onready var delete_button = $"VBoxContainer/DeleteButton"

var attempts = 5
func _on_DeleteButton_pressed():
	attempts = attempts - 1 
	delete_button.text = "Noch %d klicks" % attempts
	if attempts < 0: 
		_reset_game_state()

func _reset_game_state(): 
	Logger.print("Spielstand zurückgesetzt!", self)
	PSS.reset_game_state()
	get_tree().reload_current_scene()

func _on_ResetTutorialsButton_pressed():
	Logger.print("Tutorials zurückgesetzt!", self)
	DialogicSingleton.init(true)
	get_tree().reload_current_scene()
	
func _on_ResetCacheButton_pressed():
	Logger.print("Cache zurückgesetzt!", self)
	Api.cache.drop_cache()
	get_tree().reload_current_scene()



func _on_NavImpressum_pressed():
	GameManager.scene_manager.push_scene("res://Scenes/ImpressumEtcScene.tscn")


func _on_NavPrivacyNotice_pressed():
	OS.shell_open("https://climactivity.de/datenschutzerklaerung/")

