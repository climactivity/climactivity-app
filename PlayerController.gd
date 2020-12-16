extends Node

var player_xp
var player_coins
var player_water

var player_level
var unplaced_items = []

func save():
	return {
		"player_xp": player_xp,
		"player_level": player_level,
		"player_water": player_water,
		"player_coins": player_coins,
	}