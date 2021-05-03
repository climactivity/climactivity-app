extends Resource

export (String) var region
export (String) var language

export (int) var deadline 
export (int) var max_duration

export (String) var title 
export (String) var text 

func _init(dict = {}): 
    region = dict["region"] if dict.has("region") else "" 
    language = dict["relanguagegion"] if dict.has("language") else "" 
    deadline = dict["deadline"] if dict.has("deadline") else 0 
    max_duration = dict["max_duration"] if dict.has("max_duration") else 0
    title = dict["title"] if dict.has("title") else "" 
    text = dict["text"] if dict.has("text") else "" 

