extends Resource
class_name RLocalizedQuest

export (int) var deadline 
export (int) var max_duration
export (int) var start_date

export (String) var region
export (String) var language

export (String) var title 
export (String) var text 

export (String) var alert_tracked_aspect
export (String) var link_to_after

export (Resource) var reward # RReward

func _init(dict = {}): 
	deadline = dict["deadline"] if dict.has("deadline") else 0 
	max_duration = dict["maxDuration"] if dict.has("maxDuration") else 0
	start_date = dict["startDate"] if dict.has("startDate") else 0
	
	region = dict["region"] if dict.has("region") else "" 
	language = dict["language"] if dict.has("language") else "" 

	title = dict["title"] if dict.has("title") else "" 
	text = dict["text"] if dict.has("text") else "" 

	alert_tracked_aspect = dict["alertTrackedAspect"] if dict.has("alertTrackedAspect") else "" 
	link_to_after = dict["linkToAfter"] if dict.has("linkToAfter") else "" 
	reward = RReward.from_dict(dict["reward"]) if dict.has("reward") else load("res://Network/DefaultReward.tres")
