extends Spatial

var tree_state = {
	"stage": 2,
	"water": 5.4,
	"water_needed": 10,
	"aspekt": "ernährung/pflanzliche_ernährung" 
}

func save(): 
	return {
		"name": name,
		"scene_name": filename,
		"state": tree_state
	}
