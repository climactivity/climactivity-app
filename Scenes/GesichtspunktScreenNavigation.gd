extends Panel

var s_infobyte_card = preload("res://UI/Components/InfobyteCard.tscn")

var _navigation_data
onready var content_holder = $"VBoxContainer/MarginContainer/ScrollContainer/ContentMain/Infobyte"

func _ready():
	_show_data()

func receive_navigation(navigation_data):
	_navigation_data = navigation_data
	_show_data()

func _show_data():
	if _navigation_data == null: return 
	if content_holder == null: return
	if _navigation_data.has("factor") and _navigation_data.has("aspect"):
		return
