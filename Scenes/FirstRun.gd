extends Control

signal save_ready()

var res = []

func _ready():
	var has_restorable_state = yield(find_restorable_state(), "completed")
	if has_restorable_state: 
		$AnimationPlayer.play("Enter")
	else: 
		PSS.flush()
		emit_signal("save_ready")
		
func find_restorable_state(): 
	res = yield(NakamaConnection.read_collection("player_state"), "completed")

	if res == []:
		print("No restorable state!")
		return false
	else:
		print("Found restorable state!", res)
		return true

func restore_state(): 
	var ref = PSS.get_player_state_ref()
	ref.restore(res)
	emit_signal("save_ready")

func _exit(): 
	$AnimationPlayer.play_backwards("Enter")

func _on_Button_Restore_pressed():
	$Container/VBoxContainer/Button_New.disabled = true
	$Container/VBoxContainer/Button_Restore.disabled = true
	restore_state()
	_exit()

func _on_Button_New_pressed():
	$Container/VBoxContainer/Button_New.disabled = true
	$Container/VBoxContainer/Button_Restore.disabled = true
	emit_signal("save_ready")
	_exit()
