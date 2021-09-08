extends PanelContainer

export var grab_attention = true

func _ready(): 
	var parent = get_parent()
	if parent != null and parent.has_method("grab_attention"):
		grab_attention = parent.grab_attention()
	if grab_attention: 
		$AnimationPlayer.play("att")
	
