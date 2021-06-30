tool 
extends PanelContainer
class_name ListEntry
var bg_style = preload("res://UI/ListEntry.tres")
export var texture = preload("res://Assets/TestData/checkered.png") setget set_icon
export (String) var _content_text = "" setget set_content_text
export (Resource) var reward setget set_reward_display 
export (String) var navigation_target  = "" setget set_navigation_target
export (Dictionary) var navigation_payload = {} setget set_navigation_payload
export (Color) var accent_color = Color("95c11e") setget set_accent_color
onready var icon = $MarginContainer/HBoxContainer/IconContainer/CenterContainer/Capsule
onready var content_holder = $MarginContainer/HBoxContainer/ContentContainer
onready var content_text = $MarginContainer/HBoxContainer/ContentContainer/VBoxContainer/RichTextLabel
onready var content_reward = $MarginContainer/HBoxContainer/ContentContainer/VBoxContainer/RewardLabel
onready var go_down_tex = $MarginContainer/HBoxContainer/PanelContainer/TextureRect


var ready = false

func _ready():
	ready = true
	update()

func set_icon(tex : Texture): 
	texture = tex
	update()
	
func set_reward_display(_reward: RReward):
	reward = _reward
	update()

func set_content_text(rich_text: String):
	_content_text = rich_text
	update()

func update():
	if !ready: return  
	icon.set_icon(texture)
	if reward == null: 
		content_reward.visible = false
	else: 
		content_reward.visible = true
		content_reward.set_reward(reward)
	content_text.text = _content_text 

func set_navigation_target(target: String, payload = {}): 
	navigation_target = target
	if payload != {}:
		set_navigation_payload(payload)
		
func set_navigation_payload(any):
	navigation_payload = any

func set_accent_color(color: Color): 
	accent_color = color
	bg_style = bg_style.duplicate()
	bg_style.set_bg_color(color)
	set('custom_styles/panel', bg_style) # panel is now green


func _on_Button_pressed():
	#if scrolling: return
	Logger.print("Navigating down: %s" % navigation_target, self)
	if navigation_target != "": 
		GameManager.scene_manager.push_scene(navigation_target, navigation_payload)

func _on_Button_button_down():
	modulate = Color("#696968")

func _on_Button_button_up():
	modulate = Color.white

var last_touch_point : Vector2
func _gui_input(event):
	if event is InputEventScreenDrag: # reject input while scrolling
		_on_Button_button_up()
		return

	if event is InputEventScreenTouch: 
		print(event.position)
		if event.pressed:
			_on_Button_button_down()
			last_touch_point = event.position
		else: 
			if event.position == last_touch_point:
				_on_Button_button_up()
				_on_Button_pressed()
