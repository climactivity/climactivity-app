extends Node

signal remote_message_processed

var current_messages = [] setget , get_current_messages
#var remote_message_flags_persist_path = "user://RemoteMessageService.cfg"
#var flags
var popup = preload("res://UI/RemoteRewardPopup.tscn")
func _ready():
	NakamaConnection.connect("nk_connected", self, "remote_messages_loaded")
#	flags = ConfigFile.new()
#	var err = flags.load(remote_message_flags_persist_path)
#	if err == OK: 
#		print("loaded EventMessagesConfig")
#	else:
#		# event_flags = {"EventNotificationsSeen": {}}
#		flags.save(remote_message_flags_persist_path)

func remote_messages_loaded(): 
	var messages = yield(NakamaConnection.get_remote_messages(), "completed")
	for message in messages:
		var message_dict = JSON.parse(message.value).result
		current_messages.push_front({"data": message_dict, "meta": message})

	
func dispatch_event_notification(): 
	emit_signal("remote_message_processed") 

func get_current_messages():
	return current_messages

func has_current_messages(): 
	return current_messages != []

func show_alert_if_any(): 
	if current_messages == []:
		return false
		
	var popup_inst = popup.instance()
	popup_inst.set_data(current_messages[0])
	GameManager.overlay._show_popup(popup_inst)


func ackMessage(message): 
	var reward = message.data.reward
	RewardService.add_reward(RReward.from_dict(reward))
	NakamaConnection.consume_remote_message(message.meta)
#
#func ack_current(): 
#	for event in current_events: 
#		if event.has("eventKey"):
#			ackEvent(event.eventKey)
