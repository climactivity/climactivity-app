tool
extends Control

var _quest

func receive_navigation(data): 
	_quest = data.quest if data.quest else {}
	if !_quest: 
		return
	

