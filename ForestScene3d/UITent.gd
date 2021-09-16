extends PanelContainer

export (Dictionary) var sector_data setget set_sector_data

func set_sector_data(_s): 
	sector_data = _s

	if $Capsule != null: 
		$Capsule.set_icon(sector_data["navigation_data"]["sector_logo"])
		$Capsule.set_progress(get_progress())
		$Capsule.set_border(sector_data["sector_color"])


func get_progress():
	var sector_name = sector_data["navigation_data"]["sector"]
	var progress = AspectTrackingService.get_sector_completion(sector_name)
	Logger.print(progress,self)
	return progress * 100
