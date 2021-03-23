extends Spatial


func _ready():
	GameManager.menu.show_menu()
	GameManager.menu.set_navigation_state( MainMenu.Navigation_states.HOME ,true)

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_R and event.is_pressed()):
		start()

func start(): 
	$AnimationPlayer.play("Zoom_To_Clearing")
	$AnimationPlayer.queue("Cloud_Drag")
	$AnimationPlayer.queue("Tree_Anim")
	$AnimationPlayer.queue("Zoom_Out")
