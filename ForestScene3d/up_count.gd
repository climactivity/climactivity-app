extends Label

export var duration = 8.0 
export var start_val = 0.0
export var end_val = 18813.73

var animate = false 
export var t = 0.0 setget set_t
var display_str = "10.000 €"
var template_str_1000 = "%2d.%03d,%02d €"
var template_str_999 = "%3d,%02d €"

func animate():
	 animate = true

func set_t(new_t):
	t = new_t
	_show(t)
func _process(delta):
	if !animate: return
	t+=delta
	var count = min(end_val, Util.map_to_range(t, start_val, duration, 0.0, end_val))
	_show(count)

func _show(number):
	if number >= 1000: 
		text = template_str_1000 % [floor(number/1000),floor(fmod(number, 1000)), 100 * (number - int(number)) ]
	else:
		text = template_str_999 % [floor(fmod(number, 1000)),  100 * (number - int(number))]
