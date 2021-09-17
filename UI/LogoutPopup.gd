extends Control
signal close
signal signed_out
		
func _on_ActionNo_pressed():
	emit_signal("close")


func _on_ActionYes_pressed():
	yield(NakamaConnection.logout(), "completed")
	emit_signal("signed_out")
	emit_signal("close")
