extends PanelContainer
class_name InfoSection 

enum State { BEHIND, FOCUSED, AHEAD }
export (State) var _state = State.FOCUSED setget set_state

onready var animation_player = $AnimationPlayer
var ready = false

func _ready():
	ready = true
	update()

func _get_configuration_warning():
	if !$AnimationPlayer is AnimationPlayer: 
		return 'AnimationPlayer required!'
	return ''

func set_state(state):
	_state = state
	update()


func update(): 
	if !ready:
		return
	pass 

func enter(): 
	animation_player.play("Enter")
	
func exit(): 
	animation_player.play("Exit")

func next(): 
	pass

func prev():
	pass
	
