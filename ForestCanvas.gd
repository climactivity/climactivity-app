extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass
	#self.vi

func move(offset: Vector2) -> void: 
	print("Move by ", offset)
	transform.origin += offset


func _on_TileMap_move_view(offset):
	move(offset)
