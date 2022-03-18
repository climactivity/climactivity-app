tool
extends PanelContainer

# "win" | "loss" | "draw"
export (String, "win", "loss", "draw") var result = "win" setget set_result 

func _ready():
	update()

func set_result(p_result):
	result = p_result
	update()
	
func update(): 
	if !is_inside_tree():
		return
	match result:
		"win": 
			$WinLabel.visible = true
			$LostLabel.visible = false
			$DrawLabel.visible = false
		"loss": 
			$WinLabel.visible = false
			$LostLabel.visible = true
			$DrawLabel.visible = false
		"draw": 
			$WinLabel.visible = false
			$LostLabel.visible = false
			$DrawLabel.visible = true
