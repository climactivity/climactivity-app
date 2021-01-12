extends Node

var protocol = "https"
var base_url = "app.climactiviy.de/api/v1"
var endpoints = {
	"quiz_list": "/infobyte",
	"quiz_data": "/infobyte/%s",
	"tree_templates_list": "/tree-template",
}

onready var ws = $WS

func _ready():
	if OS.is_debug_build():
		print(OS.get_unique_id())
		if ProjectSettings.get_setting("debug/settings/network/localhost"):
			base_url = "localhost:3000"
			protocol = "http"
			
func getBaseUrl():
	return "%s://%s" % [protocol, base_url]

func getEndpoint(endpoint,request: HTTPRequest, params = []): 
	if (endpoints.has(endpoint)):	
		var requestUrl = "%s%s" % [getBaseUrl(), endpoints[endpoint]] % params
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
