extends Control

var factors 
var aspect : RLocalizedAspectData
var s_capsule = preload("res://UI/Components/FactorCapsule.tscn")
var bp_factor_list_entry = preload("res://UI/ListEntry.tscn")


func set_factors(new_factors, new_aspect):
	print("update factor list")
	factors = new_factors
	aspect = new_aspect
	_update_display() 


func _update_display():
	var sector = SectorService.get_sector_data(aspect.bigpoint)

	Util.clear(self) 
	if factors == null: 
		return
	for factor in factors: 
		var factor_list_entry = bp_factor_list_entry.instance()
		factor_list_entry.set_content_text(factor.name)
		factor_list_entry.set_navigation_target("res://Scenes/GesichtspunktScreen.tscn", {"factor": factor, "aspect": aspect, "sector": sector})
		factor_list_entry.set_accent_color(sector["sector_color"])
		if factor.has('icon'): 
			factor_list_entry.set_icon(factor.icon)
		elif aspect.icon != null: 
			factor_list_entry.set_icon(aspect.icon)
		else:
			factor_list_entry.set_icon(sector["sector_logo"])
		add_child(factor_list_entry)

