extends Sprite

var pressed = false 
var idle = true
var start_position = Vector2.ZERO 
signal cloudMoving(isSelected)


func _init(): 
	GameManager.cloud = self
# Called when the node enters the scene tree for the first time.
func _ready():

	start_position = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (idle):
		position = lerp(position, start_position, delta)
	idle = true

func _on_Area2D_input_event(viewport, event, shape_idx):
	get_tree().set_input_as_handled()
	idle = false
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position, " Hi from Cloud")
		pressed = event.pressed
		
		emit_signal("cloudMoving", pressed)

	if event is InputEventMouseMotion:
		if pressed:
			position += event.relative
			#idle = false
