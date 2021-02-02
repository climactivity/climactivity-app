extends Resource
#		JSON from server
#        bigpoint: aspect.bigpoint,
#        name: aspect.name,
#        title: aspectLocalizedStrings.strings.title,
#        forLanguage: aspectLocalizedStrings.language,
#        forRegion: region,
#        localizedTrackingData: {
#          question: localizedTrackingData.strings.question,
#          options: aspect.trackingData.options.map(option => {
#            return {
#              reward: option.reward,
#              option: localizedTrackingData.strings.options.find(locale => locale.locale_id == option.locale_id).value
#            }
#          }
#          )
#        },
#        message: error
export (String) var bigpoint
export (String) var name
export (String) var _id
export (String) var title
export (String) var language
export (String) var region
export (String) var message
export (Dictionary) var tracking
export (Dictionary) var info_graph

func _init(dict = {}):
	#if (dict == null): return
	bigpoint = dict["bigpoint"] if dict.has("bigpoint") else "" # p_bigpoint
	_id = dict["_id"] if dict.has("_id") else ""
	name = dict["name"] if dict.has("name") else "" # p_name = "",
	title = dict["title"] if dict.has("title") else "" # p_title = "",
	language = dict["forLanguage"] if dict.has("forLanguage") else "" # p_language = "DE",
	region = dict["forRegion"] if dict.has("forRegion") else "" # p_region = "DE",
	message = dict["message"] if dict.has("message") else "" # p_message = "",
	tracking = dict["localizedTrackingData"] if dict.has("localizedTrackingData") else {} # p_tracking = {},
	info_graph = dict["infoGraph"] if dict.has("infoGraph") else {} # p_info_graph = {}

func get_option_for_level(level): 
	if tracking == {}: return null
	if tracking.has("options"):
		var options = tracking.get("options")
		if options is Array:
			if options.size() > level as int:
				return options[level as int]
	return null
