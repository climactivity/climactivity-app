tool
extends Control
class_name ProgressBlip

export (Texture) var info_inactive = preload("res://Assets/Theme/blips/step_indicator_info_inactive.png")
export (Texture) var info_active = preload("res://Assets/Theme/blips/step_indicator_info_active.png")
export (Texture) var info_completed = preload("res://Assets/Theme/blips/step_indicator_info_completed.png")

export (Texture) var quiz_inactive = preload("res://Assets/Theme/blips/step_indicator_quiz_inactive.png")
export (Texture) var quiz_active = preload("res://Assets/Theme/blips/step_indicator_quiz_active.png")
export (Texture) var quiz_completed = preload("res://Assets/Theme/blips/step_indicator_quiz_completed.png")

enum BlipMode {
	INFO,
	QUIZ
}

enum BlipState {INACTIVE, ACTIVE, COMPLETED}
export (BlipState) var state = BlipState.INACTIVE setget set_state

export var mode = 0 setget set_mode

onready var texture_active = $TextureActive
onready var texture_inactive = $TextureInactive
onready var texture_done = $TextureDone
var ready = false

func set_state(_state): 

	if !ready: 
		state = _state
		return
	
	if state == _state:
		return
		
	print(state, "->", _state)
	
	match _state:
		BlipState.INACTIVE:
			if state == BlipState.ACTIVE:
				$AnimationPlayer.play("A->I")
		BlipState.ACTIVE:
			if state == BlipState.INACTIVE:
				$AnimationPlayer.play("i->A")
			else:
				$AnimationPlayer.play("C->A")
		BlipState.COMPLETED:
			$AnimationPlayer.play("A->C")
	state = _state


func set_mode(_mode): 
	mode = _mode
#	if !ready: return
#	match mode:
#		BlipMode.INFO:
#			$TextureInactive.texture = info_inactive
#			$TextureActive.texture = info_active
#			$TextureDone.texture = info_completed
#
#		BlipMode.QUIZ:
#			$TextureInactive.texture = quiz_inactive
#			$TextureActive.texture = quiz_active
#			$TextureDone.texture = quiz_completed


func _ready():
	ready = true
	set_state(state)
	set_mode(mode)



