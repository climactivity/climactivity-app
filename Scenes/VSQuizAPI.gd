class_name VSQuizAPI
extends Reference

class VSAnswer extends NakamaAsyncResult: 
	const _SCHEMA = {
		"value": {"name": "value", "type": TYPE_STRING, "required": true},
		"correct": {"name": "correct", "type": TYPE_BOOL, "required": true},
		"key": {"name": "key", "type": TYPE_STRING, "required": true},
	}

	var value : String
	var correct : bool
	var key : int

class VSPlayerAnswer extends NakamaAsyncResult: 
	
	const _SCHEMA = {
		"answer": {"name": "answer", "type": "VSAnswer", "required": true},
		"question_index": {"name": "question_index", "type": TYPE_INT, "required": true},
		"session_id": {"name": "session_id", "type": TYPE_STRING, "required": true},
		"correct": {"name": "correct", "type": TYPE_BOOL, "required": true}
	}
	
	var answer: VSAnswer
	var question_index: int
	var session_id: String
	var correct: bool
	static func create(p_ns : GDScript, p_dict : Dictionary) -> VSPlayerAnswer:
		return _safe_ret(NakamaSerializer.deserialize(p_ns, "VSPlayerAnswer", p_dict), VSPlayerAnswer) as VSPlayerAnswer

class VSQuestion extends NakamaAsyncResult:
	
	const _SCHEMA = {
		"infobyte_id": {"name": "infobyte_id", "type": TYPE_STRING, "required": true},
		"question": {"name": "question", "type": "VSQuestionData", "required": true}
	}

	var infobyte_id: String
	var question : VSQuestionData 

class VSQuestionData extends NakamaAsyncResult: 
	
	const _SCHEMA = {
		"question": {"name": "question", "type": TYPE_STRING, "required": true},
		"infobit": {"name": "infobit", "type": TYPE_INT, "required": false},
		"answers": {"name": "answers", "type": TYPE_ARRAY, "required": true, "content": "VSAnswer"},
	}

	var question : String
	var infobit : int
	var answers : Array

class VSMatchPlayerResult extends NakamaAsyncResult:

	const _SCHEMA = {
		"session_id":{"name": "session_id", "type": TYPE_STRING, "required": false},
		"player_id":{"name": "player_id", "type": TYPE_STRING, "required": false},
		"total_correct":{"name": "total_correct", "type": TYPE_REAL, "required": true},
		"total_wrong":{"name": "total_wrong", "type": TYPE_REAL, "required": true},
		"total_dnf":{"name": "total_dnf", "type": TYPE_REAL, "required": true},
		"answers":{"name": "answers", "type": TYPE_ARRAY, "required": false, "content": "VSPlayerAnswer"},
		"result":{"name": "result", "type": TYPE_STRING, "required": false},
	}
	
	var session_id : String
	var player_id : String 
	var total_correct : int 
	var total_wrong : int 
	var total_dnf : int 
	var answers : Array
	var result : String

class VSQuizState extends NakamaAsyncResult:
	
	const _SCHEMA = {
		"presences" : {"name": "presences", "type": TYPE_DICTIONARY, "required": true, "content": TYPE_DICTIONARY},
		"questions" : {"name": "questions", "type": TYPE_ARRAY, "required": false, "content": "VSQuestion"},
		"num_questions" : {"name": "num_questions", "type": TYPE_INT, "required": false},
		"current_question" : {"name": "current_question", "type": TYPE_INT, "required": false},
		"answers" : {"name": "answers", "type": TYPE_ARRAY, "required": false, "content": "VSAnswer"},
		"time_limit_question" : {"name": "time_limit_question", "type": TYPE_REAL, "required": true},
		"time_limit_result" : {"name": "time_limit_result", "type": TYPE_REAL, "required": true},
		"time_limit_intro" : {"name": "time_limit_intro", "type": TYPE_REAL, "required": true},
		"match_started" : {"name": "match_started", "type": TYPE_BOOL, "required": true},
		"show_intro" : {"name": "show_intro", "type": TYPE_BOOL, "required": true},
		"show_questions" : {"name": "show_questions", "type": TYPE_BOOL, "required": true},
		"show_complete" : {"name": "show_complete", "type": TYPE_BOOL, "required": true},
		"intro_time_left" : {"name": "intro_time_left", "type": TYPE_REAL, "required": true},
		"current_question_time_left" : {"name": "current_question_time_left", "type": TYPE_REAL, "required": true},
		"show_q_result" : {"name": "show_q_result", "type": TYPE_BOOL, "required": false},
		"show_q_result_time" : {"name": "show_q_result_time", "type": TYPE_REAL, "required": false},
		"show_result" : {"name": "show_result", "type": TYPE_BOOL, "required": false},
		"result":{"name": "result", "type": TYPE_DICTIONARY, "required": false, "content": "VSMatchPlayerResult"}
	}
	
	var presences : Dictionary
	var questions : Array
	var num_questions : int = 9
	var current_question: int = 0
	var answers : Array
	
	var time_limit_questions : float = 10.0
	var time_limit_result : float = 5.0
	var time_limit_intro : float = 3.0
	
	var match_started : bool = false
	var show_intro : bool = false
	var show_questions : bool = false
	var show_complete : bool = false
	
	var intro_time_left : float = 5.0
	var current_question_time_left : float
	var show_q_result_time : float
	var show_q_result : bool
	var show_result : bool
	var result : Dictionary
	
	static func create(p_ns : GDScript, p_dict : Dictionary) -> VSQuizState:
		var result_state = null
		if p_dict.has("result") and p_dict.result.has("state"):
			result_state = p_dict.result.state
		var _instance = _safe_ret(NakamaSerializer.deserialize(p_ns, "VSQuizState", p_dict), VSQuizState) as VSQuizState
		
		_instance.answers = p_dict.answers.duplicate()
		if _instance.result: 
			_instance.result.state = result_state
		for k in range(0,_instance.answers.size()):

			var _value = _instance.answers[k] as Dictionary
			for j in _value.keys():
				_value[j] = _safe_ret(NakamaSerializer.deserialize(p_ns, "VSPlayerAnswer", _value[j]), VSPlayerAnswer) as VSPlayerAnswer
				
		return _instance
