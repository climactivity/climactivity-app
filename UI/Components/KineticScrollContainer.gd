### from https://github.com/VitaZheltyakov/Godot-Kinetic-scrolling/blob/master/ScrollContainer.gd
## TODO adapt speed and hide/show scrollbars

signal swiping
signal scrolled(y_pos)
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
var tween: Tween

#func scroll_to(node): 
#	var target = node.rect_position.y
#	var tween = Tween.new() 
#	tween.interpolate_property()

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
			emit_signal("scrolled", get_v_scroll())
		if (scrollDirection == "Horizontal"):
			self.set_h_scroll(self.get_h_scroll() + linearScrollBias * (-event.relative.x))
			emit_signal("scrolled", get_h_scroll())
	if  (event is InputEventMouseButton) and !event.pressed:
#		last_relative = _swipePoint - event.position
		if last_relative != Vector2.ZERO:
			if tween == null:
				tween = Tween.new()
				add_child(tween)
			if (scrollDirection == "Vertical"):
				var velocity = last_relative.y * last_relative.y * (-1.0 if last_relative.y < 0 else 1)
				var time = kineticScrollTime * abs(last_relative.y)/10 
				var end_offset = self.get_v_scroll() - kineticScrollBias * velocity
				tween.remove_all()
				tween.interpolate_method(self, "set_v_scroll", self.get_v_scroll(), 
					end_offset, time, 
					Tween.TRANS_QUAD, Tween.EASE_OUT)
				tween.start()
				emit_signal("scrolled", end_offset)
			last_relative = Vector2.ZERO


func scroll_to_child(nodepath: NodePath, offset = 200): 
	var child = get_node(nodepath)
	if !is_instance_valid(child):
		print_debug("Child not found at ", nodepath)
		return
	if tween == null:
		tween = Tween.new()
		add_child(tween)
	
	tween.remove_all()
	tween.interpolate_method(self, "set_v_scroll", self.get_v_scroll(), 
		child.margin_top + offset, 0.5, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	emit_signal("scrolled", child.margin_top + offset)

# The function provides disable/enable kinetic scrolling at runtime
func setKineticScrollEnable(enable: bool):
	kineticScrollEnable = enable
	set_process_input(enable)
