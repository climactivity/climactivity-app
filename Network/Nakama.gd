extends Node
#class_name NakamaConnection
var client : NakamaClient
var session : NakamaSession
var socket : NakamaSocket

signal nk_connected
signal completed
signal cy_network_authenticated
signal notificaion_received(notification)
signal signed_out
var server_key 
var oauth_base_url
var oauth_client_id
var sent_startup_analytics = false
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
		client = Nakama.create_client(server_key, ProjectSettings.get_setting("debug/settings/network/gameserver_host"), 443, "https", 3, NakamaLogger.LOG_LEVEL.ERROR )

	socket = Nakama.create_socket_from(client)
	yield(authenticate_device_uid(), "completed") 
	yield(connect_socket(), "completed") 

	socket.connect("received_notification", self, "_on_notification")

	emit_signal("nk_connected")

### TODO
func wallet_update(delta, new_coins, old_coins): 
	pass 

func _reconnect(): 
	yield(authenticate_device_uid(), "completed")
	yield(connect_socket(), "completed")
	emit_signal("nk_connected")
	return

func logout(): 
	emit_signal("signed_out")
	yield(client.rpc_async(session, "logout"),"completed")

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
			
func get_notifications(): 
	var result : NakamaAPI.ApiNotificationList = yield(client.list_notifications_async(session, 10), "completed")
	if result.is_exception():
		print("An error occured: %s" % result)
		return
	return result.notifications

func delete_notifications(notification_ids: Array):
	var delete : NakamaAsyncResult = yield(client.delete_notifications_async(session, notification_ids), "completed")
	if delete.is_exception():
		print("An error occured: %s" % delete)
		return false
	return true

func get_user():
	if !session: 
		yield(_reconnect(), "completed")

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
	if !session: 
		_reconnect()
		yield(self, "nk_connected")
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
		analytics_store_client_device_info()
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
		return
	yield(client.rpc_async(session, "push_error", message), "completed")
	
func read_collection(collection): 
	if !session: 
		_reconnect()
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

func _read_collection_storage_objects(collection): 
	if !session: 
		_reconnect()
		yield(self, "nk_connected")
	var objects_in_collection = yield(client.list_storage_objects_async(session, collection, session.user_id, 100), "completed")
	if objects_in_collection.is_exception(): 
		Logger.error("Socket error: %s" % objects_in_collection, self)
		return []
	else:
		var objects = []
		return objects_in_collection.objects

func read_global_constants(): 
	if !session: 
		_reconnect()
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

static func get_value(storage_object): 
	if storage_object == null:
		return {}
	if storage_object is Dictionary:
		return storage_object
	return JSON.parse(storage_object.value).result

func analytics_user_activity_info(): 
#
#	if sent_startup_analytics:
#		return
#
#	sent_startup_analytics = true
	var user = yield(get_user(), "completed")
	
	var user_activity_info =  get_value(yield(_read_dict( "logins", "user_activity_info", user.id), "completed"))
	var current_timestamp = OS.get_unix_time()
	if !user_activity_info.has("logins"):
		user_activity_info["logins"] = [current_timestamp]
	else: 
		var last_login = user_activity_info["logins"]
		last_login.push_front(current_timestamp)
		last_login.resize(min(last_login.size(), 50))
	_store_dict(user_activity_info, "user_activity_info", 1, 1, "")

func analytics_store_client_device_info(): 
	var device_info = {
		"device_info": {
			"OS_Name": OS.get_name(),
			"OS_Model_Name": OS.get_model_name(),
			"App_Version": ProjectSettings.get_setting("application/config/version"), 
			"Engine": Engine.get_version_info().string,
			"Startup_Time": OS.get_splash_tick_msec(),
			"Screen_DPI": OS.get_screen_dpi(),
			"Screen_Size": OS.get_screen_size(),
			"GL_Texture_Compression": {
				"etc": OS.has_feature("etc"),
				"etc2": OS.has_feature("etc2"),
				"s3tc": OS.has_feature("s3tc"),
				"pvrtc": OS.has_feature("pvrtc"),
			}
		}
	}
	_store_dict(device_info, "device_info", 1, 1, "" )


func get_client_settings(): 
	var settings_array = yield(read_collection("settings"), "completed")
	var settings = {}
	for settings_json in settings_array: 
		var json_parse = JSON.parse(settings_json)
		if json_parse.error == OK:
			var settings_part = json_parse.result
			var key = settings_part.keys()[0]
			settings[key] = settings_part[key]
		else:
			Logger.error("JSON parse error in user settings at %s " % settings_json ,self)
	return settings

func set_client_setting(key, value): 
	var settings = yield(get_client_settings(), "completed")
	settings[key] = value
	_store_dict(settings, "settings", 1, 1, "" )

func _store_dict(dict, collection, can_read, can_write, version) :
	var objs = []
	for key in dict.keys(): 
		var value = dict[key]
		var storage_object = NakamaWriteStorageObject.new(collection, key, can_read, can_write, JSON.print({key: value}), version)
#		print(JSON.print(value))
		objs.append(storage_object)	
	var acks : NakamaAPI.ApiStorageObjectAcks = yield(client.write_storage_objects_async(session, objs), "completed")
	if acks.is_exception():
		Logger.error("An error occured: %s" % acks)
		return

func _read_dict(key, collection, userId = "", version = ""): 
	var ret = {}
	var user = yield(get_user(), "completed")
	var storage_object = yield(client.read_storage_objects_async(session, [NakamaStorageObjectId.new(collection, key, userId, version)]), "completed")
	if storage_object.is_exception():
		Logger.error("Could not read storage_object %s" % storage_object, self)
		return null
	if storage_object.objects == []:
		return {}
	return storage_object.objects[0]

func _delete_dict(key, collection, version = ""): 
	var user = yield(get_user(), "completed")
	var user_id = user.id
	var ack = yield(client.delete_storage_objects_async(session, [NakamaStorageObjectId.new(collection, key, user_id, version)]), "completed")
	if ack.exception:
		Logger.error("An error occured: %s" % ack)
	return ack

func get_remote_messages():
	return _read_collection_storage_objects("remote_messages")

func consume_remote_message(message):
	var ack = yield(_delete_dict(message.key, message.collection, message.version), "completed")
	if ack.is_exception(): 
		Logger.error("An error occured: %s" % ack)
	return ack 

func sync_player_state(player_state : RTrackingStates):
	if !session: 
		_reconnect()
		yield(self, "nk_connected")
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
