extends Control

var s_infobyte_card = preload("res://UI/ListEntry.tscn")

var _navigation_data
onready var scene = $"../../../../../../.."

func _ready():
	_show_data()

func receive_navigation(navigation_data):
	_navigation_data = navigation_data
	_show_data()

func _show_data():
	if scene == null: return
	if _navigation_data == null: return 
	if _navigation_data.has("factor") and _navigation_data.has("aspect"):
		var factor = _navigation_data["factor"]
		var aspect = _navigation_data["aspect"]
		var sector = _navigation_data["sector"]
		var infobytes = Api.get_infobytes_for_factor(_navigation_data.get("factor"), _navigation_data.get("aspect"))
		scene.set_screen_title ( _navigation_data.aspect.name if _navigation_data.has("aspect") else "Gesichtspunkte" ) 
		scene.set_accent_color(sector["sector_color"])
		if aspect.icon != null: 
				scene.set_header_icon(aspect.icon)
		else:
				scene.set_header_icon(sector["sector_logo"])
		for infobyte in infobytes: 
			var new_child = s_infobyte_card.instance()
			var infobyte_completed = InfobyteService.is_completed(infobyte._id)
			new_child.set_content_text(infobyte.name if !infobyte_completed else infobyte.name + " (geschafft)")
			new_child.set_reward_display(infobyte.reward)
			new_child.set_accent_color(sector["sector_color"])
			new_child.set_navigation_target("res://Scenes/QuizScene.tscn", {"aspect": aspect, "sector": sector,"factor": factor, "quiz": infobyte})
			if aspect.icon != null: 
				new_child.set_icon(aspect.icon)
			else:
				new_child.set_icon(sector["sector_logo"])
			new_child.is_start_hidden(true)
			add_child(new_child)

		return
