extends InfoSection

signal reward_collected

func set_result(quiz_result):
	print(quiz_result)
func set_quiz(quiz_data):
	print(quiz_data)


func _on_RewardCollector_collected(reward):
	emit_signal("reward_collected")
