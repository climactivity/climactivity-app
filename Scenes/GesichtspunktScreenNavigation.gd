extends Control

var s_infobyte_card = preload("res://UI/Components/InfobyteCard.tscn")

var _navigation_data


func _ready():
	_show_data()

func receive_navigation(navigation_data):
	_navigation_data = navigation_data
	_show_data()

func _show_data():
	if _navigation_data == null: return 
	if _navigation_data.has("factor") and _navigation_data.has("aspect"):
		var infobytes = Api.get_infobytes_for_factor(_navigation_data.get("factor"), _navigation_data.get("aspect"))
		print(infobytes)
		for infobyte in infobytes: 
			var new_child = s_infobyte_card.instance()
			add_child(new_child)
			new_child.set_infobyte(infobyte)
		return
