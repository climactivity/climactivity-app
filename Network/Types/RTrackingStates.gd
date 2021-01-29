extends Resource

export (Dictionary) var tracking_states = {}

##example value 
#{
#	"_id": 
#		{
#			"bigpoint": bigpoint,
#			"current": history[0],
#			"history": [{
#				"set_at": time_stamp,
#				"level?": level, # <- int falls discrete werte, float(0,1) falls contiuum
#				"reward": reward,
#				"value?": value
#			}]
#		}
#} 
