extends VBoxContainer

onready var shop_button_container = $shop_button_container
onready var anim_player = $AnimationPlayer
onready var tracking_question = $TrackingQuestion
onready var tracking_state_list_entry = $MarginContainer/TrackingState

var aspect_data


func show_shop_button():
	Logger.print("new seedling available", self)
	#shop_button_container.visible = true
	anim_player.play("ShowShopButton")

func _on_entity_shop_button_pressed():
	if AspectTrackingService.has_seedling_available(aspect_data):
		GameManager.scene_manager.push_scene("res://Scenes/EntityShopScene.tscn", {"aspect": aspect_data})

func set_aspect(new_aspect_data):
	aspect_data = new_aspect_data
	update()

func update():
	print('hi!')
	tracking_question.set_text(aspect_data.tracking.question)
	var current_tracking_level =  AspectTrackingService.get_current_tracking_level(aspect_data)
	var current_option = aspect_data.get_option_for_level(current_tracking_level.level) if current_tracking_level != null else null
	var text_content =  "%s:\n%s" % [tr("current_tracking_level_label"), current_option.option if current_tracking_level != null  else tr("current_tracking_level_unset") ]
	tracking_state_list_entry.set_content_text( text_content ) 
	tracking_state_list_entry.set_navigation_target("res://Scenes/TrackingSettingScene.tscn", {"aspect": aspect_data})
	if current_option != null: 
		tracking_state_list_entry.set_reward_display(current_option.reward)
	if AspectTrackingService.has_seedling_available(aspect_data):
		show_shop_button()
