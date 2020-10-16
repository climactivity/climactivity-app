extends Sprite

var pressed = false 
var idle = true
var start_position = Vector2.ZERO 
export var return_force = 0.5
export var snap_back = true
signal cloudMoving(isSelected)

func _init(): 
	GameManager.cloud = self
func _ready():
	start_position = self.position

func _process(delta):
	if (idle and snap_back):
		position = lerp(position, start_position, delta * return_force)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position, " Hi from Cloud")
		pressed = event.pressed
		idle = !event.pressed
		emit_signal("cloudMoving", pressed)

	if event is InputEventMouseMotion:
		if pressed and !idle:
			position += event.relative

func _on_Area2D_mouse_exited():
	pressed = false
	idle = true
	emit_signal("cloudMoving", false)
