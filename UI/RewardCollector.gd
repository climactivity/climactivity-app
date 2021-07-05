extends PanelContainer
export (Resource) var reward setget set_reward 
signal collected(reward)

var ready = false
var xp = 0 
var coins = 0 
export var disabled = true setget set_disabled
export var display_frac = 1.0 setget set_display_frac
export (String) var label = tr("collect") setget set_label
onready var collect_button = $VBoxContainer/CollectButton
onready var collect_button_label = $VBoxContainer/CollectButton/Label
onready var animation_player = $AnimationPlayer
onready var coins_label = $VBoxContainer/HBoxContainer/VBoxContainer/coins_label
onready var xp_label = $VBoxContainer/HBoxContainer/VBoxContainer2/xp_label
onready var coins_icon_holder = $VBoxContainer/HBoxContainer/VBoxContainer/coins_icon_holder
onready var xp_icon_holder = $VBoxContainer/HBoxContainer/VBoxContainer2/xp_icon_holder

func set_label(string): 
	label = string
	update()
	
func set_display_frac(_display_frac):
	display_frac = _display_frac
	update()

func set_disabled(val): 
	disabled = val
	update() 

func _ready():
	ready = true
	xp = reward.get("xp") if reward.get("xp") else 0
	coins = reward.get("coins") if reward.get("coins") else 0
	
func set_reward(_reward):
	reward = _reward
	xp = reward.get("xp") if reward.get("xp") else 0
	coins = reward.get("coins") if reward.get("coins") else 0
	update()

func update():
	if !ready:
		return
	if reward != null:

		collect_button_label.text = label
		collect_button.disabled = disabled
		var coins_str = "%d" % (coins * display_frac)
		var xp_str = "%d" % (xp * display_frac)
		
		coins_label.text = coins_str
		xp_label.text = xp_str
		
		coins_icon_holder.visible = coins_str != ""
		xp_icon_holder.visible = xp_str != ""
		
		if coins_str == "" and xp_str == "": 
			visible = false
			Logger.error("No reward set!", self)

func _on_button_button_down():
	collect_button.modulate = Color("#696968")

func _on_button_button_up():
	collect_button.modulate = Color.white

func _on_button_pressed():
	print("Collected")
	animation_player.play("Collect")

var last_touch_point : Vector2

func _on_CollectButton_gui_input(event):
	if event is InputEventScreenDrag: # reject input while scrolling
		_on_button_button_up()
		return

	if event is InputEventScreenTouch: 
		if event.pressed:
			_on_button_button_down()
			last_touch_point = event.position
		else: 
			if event.position == last_touch_point:
				_on_button_button_up()
				_on_button_pressed()


func _on_CollectButton_pressed():
	_on_button_pressed()

func on_collected(): 
	emit_signal("collected", reward)
