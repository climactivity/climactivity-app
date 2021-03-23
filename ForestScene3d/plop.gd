extends Spatial


var bPlop = false
var lastPlop = 0.0 
var nextPlop = 0.46

func _process(delta):
	if !bPlop: return 
	lastPlop += delta
	if get_child_count() == 0:
		queue_free()
		return
	if lastPlop > nextPlop:
		_plop(get_child(0))
		lastPlop = 0.0 
		nextPlop = 0.002 * get_child_count()
		if nextPlop < 0.01 and get_child_count() != 0:
			_plop(get_child(0))

func plop(): 
	bPlop = true

func _plop(child):
	remove_child(child)
	get_parent().add_child(child)
	child.plop()
