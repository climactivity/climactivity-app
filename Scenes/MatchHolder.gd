extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (NodePath) var controller 

func receive_navigation(_navigation_data):
	get_node(controller)._start_match(_navigation_data)
