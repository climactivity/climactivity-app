extends VBoxContainer

export var show_menu_bar = false


func _enter_tree():
	return
	if GameManager == null or GameManager.menu == null: return
	if show_menu_bar:
		GameManager.menu.show_menu()
	else:
		GameManager.menu.hide_menu()
