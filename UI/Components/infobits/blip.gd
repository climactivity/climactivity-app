tool
extends TextureRect
class_name ProgressBlip

export (Texture) var info_inactive = preload("res://Assets/Theme/blips/step_indicator_info_inactive.png")
export (Texture) var info_active = preload("res://Assets/Theme/blips/step_indicator_info_active.png")
export (Texture) var info_completed = preload("res://Assets/Theme/blips/step_indicator_info_completed.png")

export (Texture) var quiz_inactive = preload("res://Assets/Theme/blips/step_indicator_quiz_inactive.png")
export (Texture) var quiz_active = preload("res://Assets/Theme/blips/step_indicator_quiz_active.png")
export (Texture) var quiz_completed = preload("res://Assets/Theme/blips/step_indicator_quiz_completed.png")

enum BlipState {INACTIVE, ACTIVE, COMPLETED}
export (BlipState) var state = BlipState.INACTIVE setget set_state
export (ProgressBlips.BlipMode) var mode = ProgressBlips.BlipMode.INFO setget set_mode

func set_state(_state): 
	state = _state
	_update_texture()

func set_mode(_mode): 
	mode = _mode
	_update_texture()

func _update_texture(): 
	match mode:
		ProgressBlips.BlipMode.INFO:
			match state:
				BlipState.INACTIVE:
					texture = info_inactive
				BlipState.ACTIVE:
					texture = info_active
				BlipState.COMPLETED:
					texture = info_completed
		ProgressBlips.BlipMode.QUIZ:
			match state:
				BlipState.INACTIVE:
					texture = quiz_inactive
				BlipState.ACTIVE:
					texture = quiz_active
				BlipState.COMPLETED:
					texture = quiz_completed
