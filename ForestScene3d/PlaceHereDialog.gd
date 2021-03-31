extends Control



func _on_SeedlingBox_trying_to_place():
	self.visible = true
	self.mouse_filter = MOUSE_FILTER_STOP

func _on_SeedlingBox_cancle():
	self.visible = false
	self.mouse_filter = MOUSE_FILTER_IGNORE

func _on_SeedlingBox_placed(_where, _what):
	self.visible = false
	self.mouse_filter = MOUSE_FILTER_IGNORE
