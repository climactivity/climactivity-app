extends Panel


var loading = true
var bp_aspect_card = preload("res://UI/Components/AspectCard.tscn")

onready var req = $HTTPRequest
onready var aspect_list = $VBoxContainer/Content/MarginContainer/AspectList

func _fetch_data(param = null): 
	if param != null: 
		Api.getEndpoint("aspects",req, [param])
	else: 
		Api.getEndpoint("aspects", req)


func receive_navigation(navigation_data): 
	if navigation_data.has("sector"): 
		_fetch_data(navigation_data["sector"])
	else: 
		_fetch_data()

func render_aspects(aspect_data): 
	for aspect in aspect_data:
		var aspect_card = bp_aspect_card.instance()
		aspect_card.set_aspect(aspect)
		aspect_list.add_child(aspect_card)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	loading = false
	var json = JSON.parse(body.get_string_from_utf8())
	if(json.error): 
		print("Server error: ", json.error)
	else:
		print(json.result)
		render_aspects(json.result)
