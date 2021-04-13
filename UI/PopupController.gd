extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var reward_popup = preload("res://UI/RewardPopup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	RewardService.connect("reward_added", self, "show_reward")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_reward(reward):
	var new_popup = reward_popup.instance()
	new_popup.set_reward(reward)
	_show_popup(new_popup)

func _show_popup(node):
	$MarginContainer.add_child(node)
	$"../AnimationPlayer".play("ShowPopupLayer")
	node.connect("close", get_parent(), "_on_Close_Button_pressed")
	
func clear():
	Util.clear($MarginContainer)
