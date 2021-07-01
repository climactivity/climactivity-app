extends VBoxContainer

var siblings = []
export var delay = 0.3
export var stagger_delay = 1.0
export var duration = 1.0
var viewport_size
var tween
func do_the_thing():
	viewport_size = get_viewport().size
	tween = Tween.new()
	prepare()
	play()

func prepare(): 
	get_children()
	for sibling in siblings: 
		if sibling is Control and not sibling.is_in_group("behaviour"): 
			sibling.set_position ( sibling.rect_position + Vector2(viewport_size.x, 0) )
			Logger.print("Prepare %s, %d" % [sibling.name, sibling.rect_position.x], self )
			
func play():
	for sibling in siblings: 
		if sibling is Control: 
			tween.interpolate_method(sibling, "set_position", sibling.rect_position, sibling.rect_position - Vector2(viewport_size.x, 0), duration)
			Logger.print("Enter %s" % sibling.name, self )
			
