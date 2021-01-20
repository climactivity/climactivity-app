extends Node

var locale =  {
	region = "DE", 
	language = "DE"
}

var protocol = "https"
var base_url = "app.climactiviy.de/api/v1"
var endpoints = {
	"quiz_list": "/infobyte",
	"quiz_data": "/infobyte/%s",
	"tree_templates_list": "/tree-template",
	"cache-aspects": "/localized-aspect",
	"aspect_for_sector": "/localized-aspect/s/%s"
}

onready var ws = $WS
onready var req = $HTTPRequest
onready var cache = $CacheController
func _ready():
	if OS.is_debug_build():
		print(OS.get_unique_id())
		if ProjectSettings.get_setting("debug/settings/network/localhost"):
			base_url = "localhost:3000"
			protocol = "http"
	_update_cache() 
	
func getBaseUrl():
	return "%s://%s" % [protocol, base_url]

func getEndpoint(endpoint,request: HTTPRequest, params = [], localize = false): 
	if (endpoints.has(endpoint)):
		var requestUrl = "%s%s" % [getBaseUrl(), endpoints[endpoint]] % params 
		if localize:
			requestUrl += "?r=%s&l=%s" % [locale.region, locale.language]
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

# run at compile time?
func _update_cache():
	# get aspects
	cache.update()
