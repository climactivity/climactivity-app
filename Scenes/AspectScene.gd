extends Panel


onready var header = $VBoxContainer/Header
onready var tracking_settings = $"VBoxContainer/Content/MarginContainer/ScrollContainer/VBoxContainer/TrackingSettings"
onready var info_graph = $"VBoxContainer/Content/MarginContainer/ScrollContainer/VBoxContainer/InfoGraph"
onready var quests = $"VBoxContainer/Content/MarginContainer/ScrollContainer/VBoxContainer/Aufgaben"



func receive_navigation(navigation_data): 
	print(navigation_data)

