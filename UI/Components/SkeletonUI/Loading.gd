extends Control

# """ Use Panels with "use parent material and whatever stylebox to create skeleton versions of UI elements

signal finished_loading

func loading_finished():
	emit_signal("finished_loading")
	$AnimationPlayer.play("finished_loading")
	

