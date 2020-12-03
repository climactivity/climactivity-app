extends Control

# """ Use Panels with "use parent material and whatever stylebox to create skeleton versions of UI elements

func loading_finished():
	$AnimationPlayer.play("finished_loading")
