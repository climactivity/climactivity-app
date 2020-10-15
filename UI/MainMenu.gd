extends Control

export var home_screen_path = "res://MainScreen.tscn" 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HomeButton_pressed():
	Transition.transition_to("swipe_left")
