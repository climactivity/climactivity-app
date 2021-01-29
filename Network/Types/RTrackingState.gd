extends Resource

export (String) var bigpoint
export (String) var aspect
export (Resource) var current
export (Array) var history

##example value 
#{
#	"bigpoint": bigpoint,
#	"current": history[0],
#	"history": [{
#		"set_at": time_stamp,
#		"level?": level, # <- int falls discrete werte, float(0,1) falls contiuum
#		"reward": reward,
#		"value?": value
#	}]
#}
