extends LinkButton

func _ready():
	text = get_parent().name


func _on_DEBUGScreenLabel_pressed():
	OS.shell_open("https://ruhr-uni-bochum.sciebo.de/apps/onlyoffice/s/wKKH8nByDZf67Uz?fileId=988098766")
