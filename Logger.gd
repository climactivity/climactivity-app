extends Node

func print(message, caller = null):
	if ProjectSettings.get_setting("logging/file_logging/enable_file_logging") || OS.is_debug_build():
		var dt=OS.get_datetime()
		print("%02d:%02d:%02d " % [dt.hour,dt.minute,dt.second],"[%s] " % caller.name if is_instance_valid(caller) else "Global" , message)
