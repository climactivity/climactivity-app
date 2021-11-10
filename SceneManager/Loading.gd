extends Node

onready var progress_bar = $MarginContainer/VBoxContainer/MarginContainer/ProgressBar

var loader
var wait_frames
var time_max = 100 # msec
var current_scene
var b_cache_ready
var b_save_ready
export var game_root_path = "res://SceneManager/SceneManager.tscn"
export var first_run_scene = preload("res://Scenes/FirstRun.tscn")
func setProgress(progress):
	$Panel/ProgressBar.value = progress

func _ready():

	Api.connect("cache_ready", self, "cache_ready")
	call_deferred("_init_cache")
	
	if PSS.is_first_run is String:
		PSS.connect("loaded", self, "is_save_game_ready")
	else:
		is_save_game_ready(PSS.is_first_run)


func _init_cache(): 
	Api.update_cache()

func is_save_game_ready(newGame): 
	print("is_save_game_ready: ", newGame)
	b_save_ready = !newGame
	if newGame:
		var frs = first_run_scene.instance()
		add_child(frs)
		frs.connect("save_ready", self, "save_game_ready")
	enter_game(game_root_path)

func save_game_ready(): 
	b_save_ready = true
	PSS.is_first_run = false
	PSS.flush()

	if current_scene != null and b_cache_ready and b_save_ready:
		show_scene()
	
func cache_ready(): 
	b_cache_ready = true
	if current_scene != null and b_cache_ready and b_save_ready:
		show_scene()
	
func enter_game(path): 
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # scene already cached
		show_error()
	set_process(true)
	
	## play throbber or something 
	wait_frames = 1	

func show_error():
	Logger.error("It broke :(", self)
	return

func show_scene(): 
	get_tree().get_root().add_child(current_scene)
	self.queue_free()
	
func set_new_scene(res): 
	current_scene = res.instance()
	if b_cache_ready and b_save_ready: 
		show_scene()

var last_progress = 0.0
func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
#	print(progress, " ", OS.get_ticks_msec() )
	# Update your progress bar?

#	var length = anim_player.get_current_animation_length()
#	anim_player.seek(progress * length, true)
	
	var progress_value = progress * 100
	var tween_time = (float(time_max)/1000.0)
#	$Tween.interpolate_property(
#		progress_bar,
#		"value",
#		last_progress * 100,
#		progress_value,
#		tween_time,
#		Tween.TRANS_LINEAR,
#		Tween.EASE_IN_OUT)
#	$Tween.start()
	progress_bar.value = progress_value
	last_progress = progress

func _process(delta): 
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	if wait_frames > 0:
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK: 
			update_progress()
		else:
			show_error()
			loader = null
			break
