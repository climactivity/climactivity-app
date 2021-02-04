extends Node

func print(message, caller = null):
	if ProjectSettings.get_setting("logging/file_logging/enable_file_logging") || OS.is_debug_build():
		var dt=OS.get_datetime()
		print("%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second],"[%s] " % get_caller_name(caller), message)

func error(message, caller = null): 
	var dt=OS.get_datetime()
	printerr( "%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second], "[ERROR] " ,"[%s] " % get_caller_name(caller), message)

func _notification(what):
	if what == MainLoop.NOTIFICATION_CRASH:
		error(str(what))


func get_caller_name(caller): 
	var caller_name = "Global"
	if caller is String:
		caller_name = caller
	elif caller is Resource: 
		caller_name == caller.resource_name
	elif is_instance_valid(caller): 
		caller_name = caller.name 
	return caller_name

func send_log():
	pass
