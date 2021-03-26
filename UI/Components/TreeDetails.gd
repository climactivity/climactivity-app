extends PanelContainer



func _on_Button_pressed():
	if GameManager != null and GameManager.camera != null:
		GameManager.camera.unfocus_entity()
