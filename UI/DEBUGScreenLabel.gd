extends LinkButton

func _ready():
	text = get_parent().name


func _on_DEBUGScreenLabel_pressed():
	OS.shell_open("mailto:climactivity-bugs@fire.fundersclub.com?subject=Bug%20Report&body=Version:%20"+ "v: 0.1.0" +"%0AWo:%20" + get_parent().name)
