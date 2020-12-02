class_name TransitionFactory
extends Object

class SceneTransitionConfig:
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


static func MoveOut(): 
	var transition = SceneTransitionConfig.new()
	return transition

static func MoveBack():
	var transition = SceneTransitionConfig.new()
	transition.direction = directions.RIGHT
	transition.transition_name = "Move_Back"
	return transition
