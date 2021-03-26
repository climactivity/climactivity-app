extends Control

var factors 
var aspect
var s_capsule = preload("res://UI/Components/FactorCapsule.tscn")

func set_factors(new_factors, new_aspect):
	print("update factor list")
	factors = new_factors
	aspect = new_aspect
	_update_display() 


func _update_display():

	Util.clear(self) 
	for factor in factors: 
		var factor_capsule = s_capsule.instance()
		add_child(factor_capsule)
		factor_capsule.set_factor(factor, aspect)
