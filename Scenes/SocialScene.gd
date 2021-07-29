extends SceneBase

enum social_state {OFFLINE, LOGGED_OUT, LOGGED_IN}
var state = social_state.LOGGED_OUT setget set_state

onready var connect_box = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/VBoxContainer"
onready var profile_box = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/VBoxContainer2"
onready var profile_box_label = $"ContentContainer/Content/VBoxContainer/MarginContainer/ScrollContainer/ContentMain/MarginContainer/VBoxContainer2/Label"
func set_state(_state):
	state = _state
	update()

func _on_CyButton_pressed():
	NakamaConnection.connect("cy_network_authenticated", self, "_authenticated_callback")
	NakamaConnection.start_cy_network_oauth_flow()

func update():
	var user =  yield(NakamaConnection.get_user(), "completed")
	if user.display_name != "": 
		connect_box.visible = false
		profile_box.visible = true
		profile_box_label.bbcode_text = "Angemelted als " + user.display_name # + " (" + user.custom.id  + ")" 
		
func _authenticated_callback(): 
	update()
func _ready():
	update()
