extends SceneBase

var matchData : NakamaRTAPI.Match 
var socket : NakamaSocket

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _start_match(_navigation_data):
	print("_start_match ", _navigation_data)
	$ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MatchHolder/PanelContainer/VBoxContainer/Label2.text = _navigation_data.joined_match.match_id
	
	matchData = _navigation_data.joined_match
	socket = _navigation_data.socket
