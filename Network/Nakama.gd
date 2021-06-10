extends Node
class_name NakamaConnection
var client : NakamaClient
var session : NakamaSession
signal nk_connected
signal completed
func _ready():
	client = Nakama.create_client("cyserver_BVZ29wCUCJmjh2rcTrECCcDm9WdqsptDpuYyuen8tEC4WBYcYcJdjxwpmycxuxNP", "127.0.0.1", 7350, "http")
	authenticate_device_uid()


func authenticate_email(email, password): 
	session = yield(client.authenticate_email_async(email, password, false), "completed")
	emit_signal("nk_connected")
	Logger.print(session)

func update_account_with_email(email, password): 
	yield(client.link_email_async(session, email, password), "completed")

func authenticate_device_uid(): 
	var device_id = OS.get_unique_id()
	session = yield(client.authenticate_device_async(device_id), "completed")
	emit_signal("nk_connected")
	Logger.print(session, self)

func save_var(collection_name: String, key_name: String, value: String, can_read = 1, can_write = 1, version = ""): 

	var storage_object = NakamaWriteStorageObject.new(collection_name, key_name, can_read, can_write, value, version)
	var ack = yield(client.write_storage_objects_async(session, [storage_object]), "completed")
	if ack.is_exception():
		Logger.error("Socket error: %s" % ack, self)
		return false
	else:
		Logger.print("Successfully stored object: %s/%s" % [collection_name, key_name], self)
		return ack.acks[0]

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

func sync_player_state(player_state : RTrackingStates):
	if (not client or not session): 
		Logger.print("Connection not ready!", self)
		return
	var can_read = 1
	var can_write = 1
	var version = ""
	
	var player_state_dict = player_state.to_dict()
	var objs = []
	
	for key in player_state_dict.keys(): 
		var value = player_state_dict[key]
		var storage_object = NakamaWriteStorageObject.new("player_state", key, can_read, can_write, JSON.print({key: value}), version)
		print(JSON.print(value))
		objs.append(storage_object)	
	
	var acks : NakamaAPI.ApiStorageObjectAcks = yield(client.write_storage_objects_async(session, objs), "completed")
	if acks.is_exception():
		print("An error occured: %s" % acks)
		return
	print("Successfully stored objects:")
	for a in acks.acks:
		print("%s" % a)
