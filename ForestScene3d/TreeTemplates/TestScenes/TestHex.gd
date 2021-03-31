extends Spatial

export var plane_coordinates = Vector2.ZERO

func show_grid():
	if $Grid.visible: return false
	$AnimationPlayer.play("ShowGrid")
	return true
	
func show_preview():
	$AnimationPlayer.play("ShowPreview")
	
func hide():
	$AnimationPlayer.play("Hide")
