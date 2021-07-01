extends Control

func _ready(): 
	$Stagger.prepare(self)
	$Stagger.play()
