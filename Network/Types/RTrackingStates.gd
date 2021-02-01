extends Resource

export (Dictionary) var tracking_states = {}
export (Dictionary) var board_entites = {}
export (Dictionary) var inventory = {}
export (Dictionary) var level = {}
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
