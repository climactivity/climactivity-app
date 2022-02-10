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
	set_blips(blip_count)
	update()
	
func set_completed(_completed): 
	completed = _completed
	update()
	
func set_blips(count):
	blip_count = count 
	if $PanelContainer/HBoxContainer == null: return
	$PanelContainer/MarginContainer/TextureProgress.max_value =  max(blip_count - 1, 1)
	Util.clear($PanelContainer/HBoxContainer)
	for i in range(0,blip_count):
		var blip = _blip.instance()
		$PanelContainer/HBoxContainer.add_child(blip)

func set_mode(_mode):
	mode = _mode 
	update()

func set_active(_active):
	active = _active 
	update()

func next(): 
	active += 1
	active = min(active, blip_count)
	
#	$Tween.interpolate_property($PanelContainer/MarginContainer/TextureProgress, "value", active - 1, active, 0.4, Tween.TRANS_CUBIC)
#	$T
	
	update()

func prev(): 
	active += 1
	active = min(active, -1)
	update()
	
func set_state(_index, _mode): 
	# print("set_state", _index, _mode)
	set_active(_index)
	set_mode(_mode)
	
func update(): 
#	if !ready:
#		return
	if !is_inside_tree(): return
	# print("blips: ", active)
	for i in range(0,$PanelContainer/HBoxContainer.get_child_count()):
		var blip = $PanelContainer/HBoxContainer.get_child(i)

		blip.set_mode(mode)
		if i == active: 
			blip.state = ProgressBlip.BlipState.ACTIVE
		elif i > active: 
			blip.state = ProgressBlip.BlipState.INACTIVE
		else: 
			blip.state = ProgressBlip.BlipState.COMPLETED
			
	

	
	$PanelContainer/MarginContainer/TextureProgress.value = active
