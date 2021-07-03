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
	var old_state = checkbox.checked
	if mode == CheckboxMode.RADIO_BUTTONS: 
		emit_signal("disable_all")
	if (old_state): 
		checkbox._uncheck()
	else:
		checkbox._check()

func register(checkbox):
	checkbox.controller = self
	checkbox_refs.append(checkbox)
	connect("disable_all", checkbox, "_uncheck")
