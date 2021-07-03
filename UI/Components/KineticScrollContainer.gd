### from https://github.com/VitaZheltyakov/Godot-Kinetic-scrolling/blob/master/ScrollContainer.gd
## TODO adapt speed and hide/show scrollbars

signal swiping

extends ScrollContainer
# The script adds the ability to kinetic scroll for ScrollContainer
# It is necessary to check the state of the scroll when working with internal controls

# The variable allows you to disable the kinetic scroll
export var kineticScrollEnable = true
# The variable determines the direction of the scroll
export(String, "Horizontal", "Vertical") var scrollDirection = "Horizontal"
# Variable specifies how long it will continue scrolling
export var kineticScrollTime = 0.3
# The variable determines the kinetic scroll length
export var kineticScrollBias = 0.75
# The variable determines which offset to consider as a swipe
export var swipeTolerance = 50

# controls how fast the default scrolling behavior is
export var linearScrollBias = 1

var last_relative = Vector2.ZERO

# The variable shows the state of the scroll. Used to organize the work of internal controls
var swiping = false

var _swipePoint = null
var tween

func _ready():
	set_process_input(kineticScrollEnable)

func _input(event):
	
	if not (event is InputEventScreenDrag or event is InputEventMouseButton or event is InputEventMouseMotion): 
		return 
	
#	if event is InputEventMouseButton: 
#		if (!self.get_global_rect().has_point(event.position)):
#			if swiping:
#				emit_signal("swiping", false)
#			swiping = false
#			_swipePoint = null
#			return
#
	if  (event is InputEventMouseButton) and (event.pressed == true):
		if tween != null: tween.stop_all() 
		if !swiping:
			emit_signal("swiping", true)
		swiping = true
		if ((event.button_index == BUTTON_LEFT) or (event.button_index == BUTTON_RIGHT)):
			_swipePoint = event.position
	
#	if (_swipePoint != null) and (event is InputEventMouseMotion):
#		if (scrollDirection == "Horizontal"):
#			self.set_h_scroll(self.get_h_scroll() + linearScrollBias * (-event.position.x + _swipePoint.x))
#		if (scrollDirection == "Vertical"):
#			self.set_v_scroll(self.get_v_scroll() + linearScrollBias * (-event.position.y + _swipePoint.y))

	if event is InputEventScreenDrag:
		last_relative = event.relative
		if (scrollDirection == "Vertical"):
			self.set_v_scroll(self.get_v_scroll() + linearScrollBias * (-event.relative.y))
		if (scrollDirection == "Horizontal"):
			self.set_v_scroll(self.get_v_scroll() + linearScrollBias * (-event.relative.x))
	
	if  (event is InputEventMouseButton) and !event.pressed:
#		last_relative = _swipePoint - event.position
		if last_relative != Vector2.ZERO:

			if tween == null:
				tween = Tween.new()
				add_child(tween)
			if (scrollDirection == "Vertical"):
				var velocity = last_relative.y * last_relative.y * (-1.0 if last_relative.y < 0 else 1)
				var time = kineticScrollTime * abs(last_relative.y)/10 
				print(last_relative.y , "  " , time)
				tween.interpolate_method(self, "set_v_scroll", self.get_v_scroll(), 
					self.get_v_scroll() - kineticScrollBias * velocity, time , 
					Tween.TRANS_QUAD, Tween.EASE_OUT)
				tween.start()
			last_relative = Vector2.ZERO
#	if (not(event is InputEventMouseButton)) and (not(event is InputEventMouseMotion)):
#		return
#	# Check that the cursor is over the scroll area
#	if (!self.get_global_rect().has_point(event.position)):
#		if swiping:
#			emit_signal("swiping", false)
#		swiping = false
#		_swipePoint = null
#		return
#	# By pressing set the necessary variables
#	if (event is InputEventMouseButton) and (event.pressed == true): 
#		if !swiping:
#			emit_signal("swiping", true)
#		swiping = true
#		if ((event.button_index == BUTTON_LEFT) or (event.button_index == BUTTON_RIGHT)):
#			_swipePoint = event.position
#		if ((event.button_index == BUTTON_WHEEL_UP) or (event.button_index == BUTTON_WHEEL_DOWN)):
#			_swipePoint = Vector2(self.get_h_scroll(), self.get_v_scroll())
#	if (swiping) and (event is InputEventMouseButton) and (event.pressed == false):
#		# Swipe off if the cursor position has not changed
#		if ((_swipePoint - event.position).length() < swipeTolerance):
#			if swiping:
#				emit_signal("swiping", false)
#			swiping = false
#			_swipePoint = null
#			return
#		# Create a tween responsible for kinetic scrolling
#		var tween = Tween.new()
#		add_child(tween)
#		if ((event.button_index == BUTTON_LEFT) or (event.button_index == BUTTON_RIGHT)):
#			if (scrollDirection == "Horizontal"):
#				tween.interpolate_method(self, "set_h_scroll", self.get_h_scroll(), 
#					self.get_h_scroll() - kineticScrollBias*(event.position.x - _swipePoint.x), kineticScrollTime, 
#					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#			if (scrollDirection == "Vertical"):
#				tween.interpolate_method(self, "set_v_scroll", self.get_v_scroll(), 
#					self.get_v_scroll() - kineticScrollBias*(event.position.y - _swipePoint.y), kineticScrollTime, 
#					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		if ((event.button_index == BUTTON_WHEEL_UP) or (event.button_index == BUTTON_WHEEL_DOWN)):
#			if (scrollDirection == "Horizontal"):
#				tween.interpolate_method(self, "set_h_scroll", self.get_h_scroll(), 
#					self.get_h_scroll() + kineticScrollBias*(self.get_h_scroll() - _swipePoint.x), kineticScrollTime, 
#					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#			if (scrollDirection == "Vertical"):
#				tween.interpolate_method(self, "set_v_scroll", self.get_v_scroll(), 
#					self.get_v_scroll() + kineticScrollBias*(self.get_v_scroll() - _swipePoint.y), kineticScrollTime, 
#					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		tween.interpolate_callback(self, kineticScrollTime, "set", "swiping", false)
#		tween.interpolate_callback(tween, kineticScrollTime, "queue_free")
#		tween.start()
#		_swipePoint = null
#	# Scrolling while moving the cursor
#	if (_swipePoint != null) and (event is InputEventMouseMotion):
#		if (scrollDirection == "Horizontal"):
#			self.set_h_scroll(self.get_h_scroll() + linearScrollBias * (-event.position.x + _swipePoint.x))
#		if (scrollDirection == "Vertical"):
#			self.set_v_scroll(self.get_v_scroll() + linearScrollBias * (-event.position.y + _swipePoint.y))


# The function provides disable/enable kinetic scrolling at runtime
func setKineticScrollEnable(enable: bool):
	kineticScrollEnable = enable
	set_process_input(enable)
