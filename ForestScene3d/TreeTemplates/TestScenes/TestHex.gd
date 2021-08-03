extends Spatial

export var plane_coordinates = Vector2.ZERO

func show_grid():
	if $Grid.visible: return false
	$Grid.visible = true
	$Preview.visible = false
	return true
	
func show_preview():
	$Grid.visible = false
	$Preview.visible = true
#	$AnimationPlayer.play("ShowPreview")
	
func hide():
	$Grid.visible = false
	$Preview.visible = false
#	$AnimationPlayer.play("Hide")
