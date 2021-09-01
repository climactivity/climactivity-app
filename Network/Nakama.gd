extends Node
#class_name NakamaConnection
var client : NakamaClient
var session : NakamaSession
var socket : NakamaSocket

signal nk_connected
signal completed
signal cy_network_authenticated
signal notificaion_received(notification)
var server_key 
var oauth_base_url
var oauth_client_id

func _ready():
	server_key = ContextService.server_key
	oauth_base_url = ProjectSettings.get_setting("debug/settings/network/oauth_base_url")
	oauth_client_id = ContextService.oauth_client_id
	if ProjectSettings.get_setting("debug/settings/network/localgameserver"): 
		client = Nakama.create_client(server_key, ProjectSettings.get_setting("debug/settings/network/localgameserver_host"), 7350, "http", 3, NakamaLogger.LOG_LEVEL.DEBUG )
		if ProjectSettings.get_setting("debug/settings/network/localwp"):
			oauth_base_url = ProjectSettings.get_setting("debug/settings/network/local_oauth_base_url")
			oauth_client_id = ContextService.oauth_client_id_local_gs_local_wp
		else:
			oauth_client_id = ContextService.oauth_client_id_local_gs_remote_wp
	else:
		client = Nakama.create_client(server_key, ProjectSettings.get_setting("debug/settings/network/gameserver_host"), 443, "https", 3, NakamaLogger.LOG_LEVEL.DEBUG )

	socket = Nakama.create_socket_from(client)
	yield(authenticate_device_uid(), "completed") 
	yield(connect_socket(), "completed") 
	socket.connect("received_notification", self, "_on_notification")

### TODO
func wallet_update(delta, new_coins, old_coins): 
	pass 

func _reconnect(): 
	yield(authenticate_device_uid(), "completed")
	yield(connect_socket(), "completed")
	return

## notification codes, as made up by me on the fly: 
## 1xx -> Oauth things 
##        100 -> Authenticated with network 
## 2xx -> Network messages
##        201 -> received notification
##        210 -> joined team
##        220 -> challenged by team member 
##        
func _on_notification(p_notification : NakamaAPI.ApiNotification):
	Logger.print(p_notification, self)
	Logger.print(p_notification.content, self)
	match p_notification.code: 
		-1: # User X wants to chat.
			pass
		-2: # User X wants to add you as a friend.
			pass
		-3: # User X accepted your friend invite.
			pass
		-4: # You've been accepted to X group.
			pass
		-5: # User X wants to join your group.
			pass
		-6: # Your friend X has just joined the game.
			pass
		100: # Authenticated with network 
			emit_signal("cy_network_authenticated")
		201:
			emit_signal("notificaion_received", p_notification)
		_: 
			pass

func get_user():
	if !session: return null

	var account : NakamaAPI.ApiAccount = yield(client.get_account_async(session), "completed")
	if account.is_exception():
		Logger.print("An error occured: %s" % account, self)
		return null
	var user = account.user
	return user

func authenticate_email(email, password): 
	session = yield(client.authenticate_email_async(email, password, false), "completed")
	emit_signal("nk_connected")
#	Logger.print(session)

func start_cy_network_oauth_flow(): 
	if !session: return 
	var account : NakamaAPI.ApiAccount = yield(client.get_account_async(session), "completed")
	if account.is_exception():
		Logger.print("An error occured: %s" % account, self)
		return
	var user = account.user
	var auth_url = "%s/authorize?response_type=code&client_id=%s&state=%s" % [oauth_base_url, oauth_client_id, user.id]
	OS.shell_open(auth_url)

func update_account_with_email(email, password): 
	yield(client.link_email_async(session, email, password), "completed")

func authenticate_device_uid(): 
	var device_id = OS.get_unique_id()
	session = yield(client.authenticate_device_async(device_id), "completed")
	if session.valid: 
		emit_signal("nk_connected")
		Logger.print(session, self)
		
	else:
		Logger.error(session._to_string(), self)

func connect_socket(): 
	if not session:
		Logger.print("Session required for socket connection", self)
		return
	var connected : NakamaAsyncResult = yield(socket.connect_async(session), "completed")
	if connected.is_exception(): 
		Logger.print("Socket could not connect: %s" % connected, self)
		return
	Logger.print("Socket connected", self)

func save_var(collection_name: String, key_name: String, value: String, can_read = 1, can_write = 1, version = ""): 
	var storage_object = NakamaWriteStorageObject.new(collection_name, key_name, can_read, can_write, value, version)
	var ack = yield(client.write_storage_objects_async(session, [storage_object]), "completed")
	if ack.is_exception():
		Logger.error("Socket error: %s" % ack, self)
		return false
	else:
		Logger.print("Successfully stored object: %s/%s" % [collection_name, key_name], self)
		return ack.acks[0]

func push_error(message): 
	if !session:
		yield(self, "nk_connected")
	yield(client.rpc_async(session, "push_error", message), "completed")
	
func read_collection(collection): 
	if !session:
		yield(self, "nk_connected")
	var objects_in_collection = yield(client.list_storage_objects_async(session, collection, session.user_id, 100), "completed")
	if objects_in_collection.is_exception(): 
		Logger.error("Socket error: %s" % objects_in_collection, self)
		return []
	else:
		var objects = []
		for object in objects_in_collection.objects:
			objects.append(object.value)
		return objects

func read_global_constants(): 
	if !session:
		yield(self, "nk_connected")
	var objects_in_collection = yield(client.list_storage_objects_async(session, "game_constants", "", 100), "completed")
	if objects_in_collection.is_exception(): 
		Logger.error("Socket error: %s" % objects_in_collection, self)
		return []
	else:
		var objects = {}
		for object in objects_in_collection.objects:
			objects[object.key] = JSON.parse(object.value)
		return objects

func analytics_store_viewed_tutorials():
	var definitions = DialogicSingleton.get_definitions()
	var completed_tutorials = {}
	for def in definitions.variables: 
		if def.value == "1":
			def['at'] = Util.date_as_RFC1123(OS.get_datetime())
			completed_tutorials[def.name] = def
		
	_store_dict(completed_tutorials, "completed_tutorials", 1, 1, "" )

func _store_dict(dict, collection, can_read, can_write, version) :
	var objs = []
	for key in dict.keys(): 
		var value = dict[key]
		var storage_object = NakamaWriteStorageObject.new(collection, key, can_read, can_write, JSON.print({key: value}), version)
#		print(JSON.print(value))
		objs.append(storage_object)	
	var acks : NakamaAPI.ApiStorageObjectAcks = yield(client.write_storage_objects_async(session, objs), "completed")
	if acks.is_exception():
		print("An error occured: %s" % acks)
		return
#	print("Successfully stored objects:")
#	for a in acks.acks:
#		print("%s" % a)


func sync_player_state(player_state : RTrackingStates):
	if (not client or not session): 
		Logger.print("Connection not ready!", self)
		return
	var can_read = 1
	var can_write = 1
	var version = ""
	
	var player_state_dict = player_state.to_dict()
	_store_dict(player_state_dict, "player_state", can_read, can_write, version )
#	var objs = []
#
#	for key in player_state_dict.keys(): 
#		var value = player_state_dict[key]
#		var storage_object = NakamaWriteStorageObject.new("player_state", key, can_read, can_write, JSON.print({key: value}), version)
##		print(JSON.print(value))
#		objs.append(storage_object)	
#
#	var acks : NakamaAPI.ApiStorageObjectAcks = yield(client.write_storage_objects_async(session, objs), "completed")
#	if acks.is_exception():
#		print("An error occured: %s" % acks)
#		return
##	print("Successfully stored objects:")
#	for a in acks.acks:
#		print("%s" % a)
