extends Node

var siblings = []
export var delay = 0.3
export var stagger_delay = 1.0
export var duration = 1.0
var viewport_size
onready var tween = $Tween
func _ready():
	viewport_size = get_viewport().size


func prepare(node): 
	get_siblings(node)
	for sibling in siblings: 
		if sibling is Control and not sibling.is_in_group("behaviour"): 
			sibling.set_position ( sibling.rect_position + Vector2(viewport_size.x, 0) )
			Logger.print("Prepare %s, %d" % [sibling.name, sibling.rect_position.x], self )
			
func play():
	for sibling in siblings: 
		if sibling is Control: 
			tween.interpolate_method(sibling, "set_position", sibling.rect_position, sibling.rect_position - Vector2(viewport_size.x, 0), duration)
			Logger.print("Enter %s" % sibling.name, self )
			
func get_siblings(node): 
	var parent = node
	siblings = parent.get_children()

	
