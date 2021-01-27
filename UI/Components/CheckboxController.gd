extends Node

signal disable_all

enum CheckboxMode {
	RADIO_BUTTONS,
	CHECKBOXES
}

var checkbox_refs = []
export(CheckboxMode) var mode = CheckboxMode.RADIO_BUTTONS

func toggle_state(checkbox):
	if !checkbox_refs.has(checkbox): 
		Logger.error("Checkbox is not controlled by this controller!", self)
		return
	if mode == CheckboxMode.RADIO_BUTTONS: 
		emit_signal("disable_all")
	for checkbox in checkbox_refs: 
		pass
