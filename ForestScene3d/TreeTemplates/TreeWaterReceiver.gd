extends StaticBody

signal getting_watered(amount)
signal cloud_dropped()

func _ready():
	$CollisionShape.disabled = false
	
func water(pos, water): 
	print("cloud dropped")
	emit_signal("cloud_dropped")

func can_drop(position, water_amount):
	emit_signal("getting_watered", water_amount)
	$CollisionShape.disabled = true
