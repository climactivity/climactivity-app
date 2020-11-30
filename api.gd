extends Node

var protocol = "https"
var base_url = "app.climactiviy.de/api/v1"
var endpoints = {
	"quiz_list": "/infobytes",
	"quiz_data": "/infobytes/%s",
}


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
