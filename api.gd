extends Node

var protocol = "https"
var base_url = "app.climactiviy.de/api/v1"
var endpoints = {
	"quiz_list": "/infobyte",
	"quiz_data": "/infobyte/%s",
}

func _ready():
	if OS.is_debug_build():
		if ProjectSettings.get_setting("debug/settings/network/localhost"):
			base_url = "localhost:3000"
			protocol = "http"
			
func getBaseUrl():
	return "%s://%s" % [protocol, base_url]

func getEndpoint(endpoint,request: HTTPRequest): 
	if (endpoints.has(endpoint)):	
		var requestUrl = "%s%s" % [getBaseUrl(), endpoints[endpoint]]
		Logger.print( "get " + endpoint + " -> GET " + requestUrl, self)
		request.request(requestUrl)
	else:
		Logger.error("Invald endpoint: " + str(endpoint), self)
		
func getQuizList(request: HTTPRequest): 
	var requestUrl = "%s%s" % [getBaseUrl(), endpoints.quiz_list]
	Logger.print("getQuizList, target: " + requestUrl, self)
	request.request(requestUrl)
	
func getQuizData(request, id): 
	var requestUrl = "%s%s" % [getBaseUrl(), endpoints.quiz_data] % id
	Logger.print("getQuizData, target: " + requestUrl, self)
	request.request(requestUrl)
