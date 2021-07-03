extends CheckBox
signal checked
signal unchecked

var controller 
export(bool) var checked
#onready var check_box = $Control
func _ready(): 
	if controller == null: 
#		Logger.error("No controller for checkbox", self)
		return
	controller.connect("uncheck_all", self, "_uncheck")
	
func _check(): 
	checked = true
	pressed = true
	emit_signal("checked")
	
func _uncheck(): 
	checked = false
	pressed = false
	emit_signal("unchecked")
	
func _on_Control_pressed():
	if controller != null: 
		controller.toggle_state(self)
