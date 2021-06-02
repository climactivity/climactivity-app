extends Node

var client : NakamaClient
var session : NakamaSession

func _ready():
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")


func authenticate(email, password): 
	session = yield(client.authenticate_email_async(email, password), "completed")
	Logger.print(session)
