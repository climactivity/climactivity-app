extends Resource
class_name RInfoByte

export (Array) var info_bits
export (Array) var questions
export (Resource) var reward
export (int) var difficulty

export (String) var _id
export (String) var name
export (String) var frontmatter
export (String) var locale
export (String) var lang
export (String) var aspect

func _init(dict = {}):
	_id = dict["_id"] if dict.has("_id") else ""
	name = dict["name"] if dict.has("name") else ""
	frontmatter = dict["frontmatter"] if dict.has("frontmatter") else ""
	locale = dict["locale"] if dict.has("locale") else "DE"
	lang = dict["lang"] if dict.has("lang") else "DE"
	info_bits = dict["infobits"] if dict.has("infobits") else []
	questions = dict["questions"] if dict.has("questions") else []
	reward =  dict["reward"] if dict.has("reward") else null
	difficulty =  dict["difficulty"] if dict.has("difficulty") else 0
	aspect =  dict["aspect"] if dict.has("aspect") else "pool"
