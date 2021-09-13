extends PanelContainer

var instance_resource
var water
var min_water = 0
var max_water
var stage
var ready = false

onready var progress_bar = $ProgressBar
onready var tween = $Tween
func _ready():
	ready = true

func show():
	$AnimationPlayer.play("Activate")

func hide():
	$AnimationPlayer.play_backwards("Activate")
	
func set_instance(_instance):
	instance_resource = _instance
	update()
	_update_current_progress(water)
func update():
	if !ready: return
	water = instance_resource.water_applied
	max_water = instance_resource.water_required
	stage = float(instance_resource.stage)
	
func _update_current_progress(new_water): 
	var progress =  Util.frac_percent(new_water, min_water, max_water)
#	if Logger != null:
#		Logger.print("_update_current_progress(%d)" % progress, self )
	progress_bar.value = progress if stage < 4 else 100

func _after_update():
	update()
	

func add_water(_water):
#	if Logger != null:
#		Logger.print("_update_current_progress(%d)" % _water, self )
	update()
	tween.interpolate_method(self, "_update_current_progress",water, _water + water, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_callback(self, 1.5, "_after_update")
	tween.start()
