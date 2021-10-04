extends Node

const FILE_PATH = 'user://remote_config.cfg'

const DEFAULTS = {
	"ui": {
		"3dClickAcceptanceRadius": 5.0, 
		"2dClickAcceptanceRadius": 5.0,
	},
	"tracking": {
		"TrackingPeriodsShort": [1,2,4,7,28], 
		"TrackingPeriodsLong": [7,28,28*3,365],
	},
	"gamelogic": {
		"InfoCompletionWeight": 1.0,
		"TrackingCompletionWeight": 1.0,
		"QuestCompletionWeight": 0.0,
		"TrackingTypeWeight": 1.0
	},
	"events": {
		"key": "",
		"relevant": {
			
		}
	}
}

signal remote_conifg_loaded

var config
var loaded = false
func _ready():
	config = ConfigFile.new()
	var err = config.load(FILE_PATH)
	if err == OK: 
		pass
#		
	if err == ERR_FILE_NOT_FOUND: 
		for defaults_section in DEFAULTS: 
			var section = DEFAULTS[defaults_section]
			for default in section: 
				config.set_value(defaults_section, default, section[default])

	## nk 
	if NakamaConnection: 
		var remote_config = yield(NakamaConnection.read_global_constants(), "completed")
		for section in remote_config:
			var keys : Dictionary = remote_config[section].result
			for key in keys:
				config.set_value(section, key, keys[key])
	config.save(FILE_PATH)
	loaded = true
	emit_signal("remote_conifg_loaded")
#	for section in config.get_sections(): 
#		for key in config.get_section_keys(section):
#			config.get_value(section, key, DEFAULTS[section][key] if DEFAULTS.has(section) and DEFAULTS[section].has(key) else null)
func get(setting: String, default = null): 
	var _vars = setting.split('/', true, 1)
	var section = _vars[0]
	var key = _vars[1]
	if !loaded:
		return DEFAULTS[section][key] if DEFAULTS.has(section) and DEFAULTS[section].has(key) else default
	return config.get_value(section, key, DEFAULTS[section][key] if DEFAULTS.has(section) and DEFAULTS[section].has(key) else default)
	
