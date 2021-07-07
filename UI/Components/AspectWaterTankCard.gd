extends MarginContainer

signal collect(tracking_data)

var ready = false
var aspect_tracking_data setget set_aspect_data
var aspect_data
var bg_color = Color('#b8b8b8') setget set_color

onready var icon = $"HBoxContainer/AspectIcon"
onready var tracking_label = $"HBoxContainer/VBoxContainer/tracking_label"
onready var selected_label = $"HBoxContainer/VBoxContainer/selected_level"
onready var water_tank = $"HBoxContainer/WaterTank"
onready var bg = $MarginContainer/Panel

var sector_data setget set_sector_data

func _ready(): 
	ready = true
	water_tank.connect("clicked", self, "collect_water")
	update()

func set_sector_data(_sector_data):
	sector_data = _sector_data
	update() 

func update(): 
	if !ready or aspect_data == null or sector_data == null:
		return

	tracking_label.text = aspect_data.name
	icon.set_icon(aspect_data.icon if aspect_data.icon else sector_data["sector_logo"])
	if aspect_tracking_data != null and aspect_tracking_data.current != null:
		var current_option = aspect_data.get_option_for_level(aspect_tracking_data.current.level)
		if current_option != null:

			selected_label.text = current_option.option
			water_tank.set_percent(aspect_tracking_data.get_water_percent_available())
	if bg_color != null:
		bg.self_modulate = bg_color

func set_aspect_data(aspect):
	aspect_tracking_data = aspect
	aspect_data = aspect_tracking_data.get_aspect_data()
	update()

func set_color(color):
	bg_color = color
	update()

func collect_water():
	if aspect_tracking_data == null: return
	emit_signal("collect", aspect_tracking_data)
	if is_instance_valid(AspectTrackingService): AspectTrackingService.water_collected(aspect_tracking_data)
	var start = aspect_tracking_data.get_water_percent_available()
	$Tween.interpolate_property(water_tank, "percent", start,
		0.0, 0.4,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Tween_tween_step(object, key, elapsed, value):
	print(value)
