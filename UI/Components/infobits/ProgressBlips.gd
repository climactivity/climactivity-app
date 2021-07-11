tool
extends Control


export (PackedScene) var _blip


export (int) var blip_count = 5 setget set_blips
export (ProgressBlip.BlipMode) var mode = ProgressBlip.BlipMode.INFO setget set_mode
export var active = 0 setget set_active
var completed = 0 setget set_completed

var ready = false 

func _ready():
	ready = true 
	update()
func set_completed(_completed): 
	completed = _completed
	update()
	
func set_blips(count):
	blip_count = count 
	update()

func set_mode(_mode):
	mode = _mode 
	update()

func set_active(_active):
	active = _active 
	update()

func next(): 
	active += 1
	active = min(active, blip_count)
	update()

func prev(): 
	active += 1
	active = min(active, -1)
	update()
	
func update(): 
#	if !ready:
#		return
	if !is_inside_tree(): return
	print("blips: ", active)
	Util.clear($HBoxContainer)
	for i in range(0,blip_count):
		var blip = _blip.instance()
		$HBoxContainer.add_child(blip)
		blip.set_mode(mode)
		if i == active: 
			blip.state = ProgressBlip.BlipState.ACTIVE
		elif i > active: 
			blip.state = ProgressBlip.BlipState.INACTIVE
		else: 
			blip.state = ProgressBlip.BlipState.COMPLETED
