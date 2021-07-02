extends Node

export var delay = 0.2
export (String) var call_group = "animatable"

export var autoplay = false

func _ready(): 
	if autoplay:
		call_deferred("play_enter")
	
func play_enter(): 
	var candidates = get_parent().get_children()
	var targets = []
	for c in candidates:
			if c.is_in_group(call_group):
				targets.append(c)
				print("%s will animate" % c.name)
	for t in targets: 
		if is_inside_tree():
			yield(get_tree().create_timer(delay), "timeout")
			if t.has_method("play_enter"):
				t.play_enter()
				print("%s entered" % t.name)
