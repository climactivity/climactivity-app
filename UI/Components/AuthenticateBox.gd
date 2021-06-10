extends PanelContainer

func _on_AuthButton_pressed():
	var email_string = $VBoxContainer/EmailEdit.text
	var password_string = $VBoxContainer/PasswordEdit.text
	
	#NakamaConnection.update_account_with_email(email_string, password_string)
