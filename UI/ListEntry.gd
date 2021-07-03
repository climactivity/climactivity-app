tool 
extends PanelContainer
class_name ListEntry
var bg_style = preload("res://UI/ListEntry.tres")
export var texture = preload("res://Assets/TestData/checkered.png") setget set_icon
export (String) var _content_text = "" setget set_content_text
export var grab_attention = false setget ,grab_attention
export (Resource) var reward setget set_reward_display 
export (String) var navigation_target  = "" setget set_navigation_target
export (Dictionary) var navigation_payload = {} setget set_navigation_payload
export (Color) var accent_color = Color("95c11e") setget set_accent_color
export (PackedScene) var button_replacement
export var start_hidden = false setget is_start_hidden
var has_entered_scene_animated = false

export var progress_icon_tex = preload("res://Assets/Icons/Time Circle.png") setget set_progress_icon
export var show_progress = false setget set_is_show_progress 

onready var icon = $MarginContainer/HBoxContainer/IconContainer/CenterContainer/Capsule
onready var content_holder = $MarginContainer/HBoxContainer/ContentContainer
onready var content_text = $MarginContainer/HBoxContainer/ContentContainer/VBoxContainer/RichTextLabel
onready var content_reward = $MarginContainer/HBoxContainer/ContentContainer/VBoxContainer/RewardLabel
onready var go_down_tex = $MarginContainer/HBoxContainer/PanelContainer/TextureRect
onready var go_down_container = $MarginContainer/HBoxContainer/PanelContainer
onready var progress_bar = $"MarginContainer/HBoxContainer/ContentContainer/VBoxContainer/MarginContainer/PanelContainer/MarginContainer/ProgressBar"
onready var progress_icon = $"MarginContainer/HBoxContainer/ContentContainer/VBoxContainer/MarginContainer/PanelContainer/AspectRatioContainer/TextureRect"
onready var progress_container = $"MarginContainer/HBoxContainer/ContentContainer/VBoxContainer/MarginContainer"
var ready = false

func grab_attention():
	return grab_attention 

func is_start_hidden(_start_hidden):
	start_hidden = _start_hidden
	if ready:
		_start_hidden()

func set_progress_icon(_progress_icon_texture): 
	progress_icon_tex = _progress_icon_texture
	update()

func set_is_show_progress(_show_progress): 
	show_progress = _show_progress
	update()
	
func _start_hidden(): 
	if Engine.is_editor_hint():
		return
	if has_entered_scene_animated:
		return
	if start_hidden: 
		$AnimationPlayer.play("hide")
#		DEBUG_print()
	else:
#		has_entered_scene_animated = true
		$AnimationPlayer.play("RESET")

func _ready():
	ready = true
	update()
	_start_hidden()

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
	progress_icon.texture = progress_icon_tex
	progress_container.visible = show_progress
	if reward == null: 
		content_reward.visible = false
	else: 
		content_reward.visible = true
		content_reward.set_reward(reward)
	content_text.text = _content_text 
	if button_replacement != null: 
		go_down_tex.visible = false
		if go_down_container.get_children().size() == 1: 
			go_down_container.add_child(button_replacement.instance())
	else: 
		go_down_tex.visible = true

	
func set_navigation_target(target: String, payload = {}): 
	navigation_target = target
	if payload != {}:
		set_navigation_payload(payload)
		
func set_navigation_payload(any):
	navigation_payload = any

func set_accent_color(color: Color): 
	accent_color = color
	if Engine.is_editor_hint():
		return
	bg_style = bg_style.duplicate()
	bg_style.set_bg_color(color)
	set('custom_styles/panel', bg_style)


func play_enter():
	has_entered_scene_animated = true
	$AnimationPlayer.play("Enter")

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
		if event.pressed:
			_on_Button_button_down()
			last_touch_point = event.position
		else: 
			if event.position == last_touch_point:
				_on_Button_button_up()
				_on_Button_pressed()


func DEBUG_print():
	print("hiding %s" % name, ", has_entered_scene_animated: " + str(has_entered_scene_animated), ", start_hidden: "  + str(start_hidden))
