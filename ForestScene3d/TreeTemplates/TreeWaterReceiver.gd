extends StaticBody

signal getting_watered(amount)

func water(): 
	print("cloud dropped")

func can_drop(position, water_amount):
	emit_signal("getting_watered", water_amount)
