extends Node

#var config

var server_key 
var oauth_client_id
var oauth_client_id_local_gs_remote_wp
var oauth_client_id_local_gs_local_wp

func _ready():
	var config = ConfigFile.new()
	var err = config.load("res://.secrets.cfg")
	if err == OK:
		server_key = config.get_value("network", "server_key")
		oauth_client_id = config.get_value("network", "oauth_client_id")
		oauth_client_id_local_gs_remote_wp = config.get_value("network", "oauth_client_id_local_gs_remote_wp")
		oauth_client_id_local_gs_local_wp = config.get_value("network", "oauth_client_id_local_gs_local_wp")
	else:
		Logger.error("A .secrets.cfg file is required for networking, please cp .secrets.cfg.template .secrets.cfg and fill in the blank values.")
	
