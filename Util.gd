extends Node

static func map_to_range(x,a,b,c,d): 
	return (x-a)/(b-a) * (d-c) + c
