class_name SceneTransitionConfig
extends Node

var transition_name = "Move_Out"
var direction  = directions.LEFT
var curve: Curve = preload("res://SceneManager/EaseOut.tres")
var speed: float = 300 #ms 

const directions = {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3,
} 
