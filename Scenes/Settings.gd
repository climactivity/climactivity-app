extends MarginContainer

onready var delete_button = $"VBoxContainer/DeleteButton"

var attempts = 5
func _on_DeleteButton_pressed():
	attempts = attempts - 1 
	delete_button.text = str(attempts)
	if attempts < 0: 
		_reset_game_state()

func _reset_game_state(): 
	PSS.reset_game_state()
	get_tree().reload_current_scene()
