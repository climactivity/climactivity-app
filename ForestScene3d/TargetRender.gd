extends Spatial


func _ready():
	GameManager.menu.show_menu()
	GameManager.xp_bar.show()
	GameManager.menu.set_navigation_state( MainMenu.Navigation_states.HOME ,true)

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_R and event.is_pressed()):
		start()
	if (event is InputEventScreenTouch and event.is_pressed()):
		start()
	if event.is_action_pressed("screenshot"):
		do_screenshot(true)
		

func start(): 
	GameManager.overlay.show_available_tutorial("Intro")
	if GameManager.menu != null: GameManager.menu.show_menu()
	if GameManager.xp_bar != null: GameManager.xp_bar.show()
	$AnimationPlayer.play("RESET")
	#$AnimationPlayer.play("Zoom_To_Clearing")
	#$AnimationPlayer.queue("Cloud_Drag")
	#$AnimationPlayer.queue("Tree_Anim")
	$AnimationPlayer.queue("Zoom_Out")

func do_screenshot(show_hud = false):
	print("click")
	GameManager.overlay.visible = show_hud
	var img = get_tree().get_root().get_viewport().get_texture().get_data()
	img.flip_y()

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# save to a file
	img.save_png("user://screenshot.png")
	GameManager.overlay.visible = true
