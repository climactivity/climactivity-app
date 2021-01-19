extends Node

signal entity_update(entity_id, update)

# The URL we will connect to
export var websocket_url = "wss://app.climactiviy.de/api/v1/heartbeat"

# Our WebSocketClient instance
var _client = WebSocketClient.new()

var initial_payload = {
	"type": "connect",
	"version": "v=0.1.0",
	"install_id":   OS.get_unique_id()
}


func _ready():

	if OS.is_debug_build():
		if ProjectSettings.get_setting("debug/settings/network/localhost"):
			websocket_url = "ws://localhost:3000/heartbeat"

	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	Logger.print("Socket connected", self)
	_put_greeting()

func _on_data():
	var _received_data = _get_packet()
	if _received_data == "connected":
		return
	var data = JSON.parse(_received_data)
	if data.error != OK:
		Logger.error(data.error, self)
	elif !data.result.has("type"):
		Logger.error("Malformed server message, missing 'type': " + str(data.result), self)
	else: 
		_dispatch_data(data.result)
		
func _dispatch_data(data):
	match data.get("type"): 
		"greeting":
			_on_greeting(data)
		_:
			Logger.error("Cannot use type: " + str(data.get("type")), self)
			
func _get_packet(): 
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	return _client.get_peer(1).get_packet().get_string_from_utf8()
	

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

func _put_dict(dict: Dictionary):
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	 _client.get_peer(1).put_packet(JSON.print(dict).to_utf8())
	
func _put_greeting(): 
	_put_dict(initial_payload)

func _on_greeting(data):
	var needs_update = !data["clientSupported"]
	if needs_update: 
		Logger.error("Needs update!", self)
	else:
		Logger.print("Server supports client version", self)
