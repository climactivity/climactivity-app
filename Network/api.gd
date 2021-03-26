extends Node

signal finished_cache
signal cache_ready

var locale =  {
	region = "DE", 
	language = "DE"
}

var headers = ["User-Agent: climactivity-app", "Content-Type: application/json"]
var protocol = "https"
var base_url = "app.climactivity.de/api"
var endpoints = {
	"quiz_list": "/infobyte",
	"quiz_data": "/infobyte/%s",
	"tree_templates_list": "/tree-template",
	"cache-aspects": "/localized-aspect",
	"aspect_for_sector": "/localized-aspect/s/%s",
	"check-cache": "/client-cache",
	"update-cache": "/client-cache/update",
	"sync-player-state": "/player-state/sync"
}

enum network_status_options {
	CONNECTED_LAN,
	CONNECTED_WAN,
	DOWN
}

var network_status = network_status_options.CONNECTED_LAN setget set_network_status, get_network_status

var enqueued_tasks = []

onready var ws = $WS
onready var req = $HTTPRequest
onready var cache = $CacheController

func _ready():
	if OS.is_debug_build():
		#print(OS.get_unique_id())
		if ProjectSettings.get_setting("debug/settings/network/localhost"):
			base_url = "localhost:3000"
			protocol = "http"
	update_cache() 
	if get_tree().has_method("standalone"): print("Got it")
	
func getBaseUrl():
	return "%s://%s" % [protocol, base_url]

func getEndpoint(endpoint,request: HTTPRequest, params = [], localize = false, method = HTTPClient.METHOD_GET, body = null ): 
	if (endpoints.has(endpoint)):
		var requestUrl = "%s%s" % [getBaseUrl(), endpoints[endpoint]] % params 
		if localize:
			requestUrl += "?r=%s&l=%s" % [locale.region, locale.language]
		Logger.print( "get " + endpoint + " -> GET " + requestUrl, self)
		request.request(requestUrl, headers, true, method, body if body != null else "")
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

func push_tracking_state(state):
	if network_status == network_status_options.CONNECTED_LAN:
		# TODO sync on tracking update if possible
		pass
	pass

# also run at compile time with BuildCache.gd
func update_cache():
	# get aspects
	cache.update()

func get_aspect_data_for_sector(sector): 
	return cache.get_aspect_data_for_sector(sector)

func get_aspect_by_name(name):
	return cache.get_aspect_by_name(name)

func get_tree_templates():
	return cache.get_tree_templates()

func is_cache_ready():
	return cache.is_ready()

func set_network_status(new_status):
	network_status = new_status 
	
func get_network_status():
	return network_status

func sync_player_state(immediate = false): 
	if get_network_status() == network_status_options.CONNECTED_LAN: 
		_sync_player_state()
	elif get_network_status() == network_status_options.CONNECTED_WAN:
		if immediate:
			_sync_player_state()
	else: 
		enqueued_tasks.push_back("_sync_player_state")

func _sync_player_state(): 
	return 
	#getEndpoint("sync-player-state", req, [], false, HTTPClient.METHOD_GET)
	#PSS.update()
