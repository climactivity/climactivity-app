extends Control



func _on_SeedlingBox_trying_to_place():
	self.visible = true


func _on_SeedlingBox_cancle():
	self.visible = false


func _on_SeedlingBox_placed(_where, _what):
	self.visible = false
