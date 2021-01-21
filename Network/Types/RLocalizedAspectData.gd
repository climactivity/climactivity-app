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
export (String) var title
export (String) var language
export (String) var region
export (String) var message
export (Dictionary) var tracking
export (Dictionary) var info_graph



#func _init(
#	p_bigpoint = "",
#	p_name = "",
#	p_title = "",
#	p_language = "DE",
#	p_region = "DE",
#	p_message = "",
#	p_tracking = {},
#	p_info_graph = {}
#):
#	bigpoint = p_bigpoint
#	name = p_name
#	title = p_title
#	language = p_language
#	region = p_region
#	message = p_message
#	tracking = p_tracking
#	info_graph = p_info_graph
	
func _init(dict):
	bigpoint = dict["bigpoint"] if dict.has("bigpoint") else "" # p_bigpoint
	name = dict["name"] if dict.has("name") else "" # p_name = "",
	title = dict["title"] if dict.has("title") else "" # p_title = "",
	language = dict["forLanguage"] if dict.has("forLanguage") else "" # p_language = "DE",
	region = dict["forRegion"] if dict.has("forRegion") else "" # p_region = "DE",
	message = dict["message"] if dict.has("message") else "" # p_message = "",
	tracking = dict["localizedTrackingData"] if dict.has("localizedTrackingData") else {} # p_tracking = {},
	info_graph = dict["infoGraph"] if dict.has("infoGraph") else {} # p_info_graph = {}
