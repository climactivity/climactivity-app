extends Resource

export (float) var xp
export (float) var coins 
export (float) var level # todo do things with that, also needs a levelup table thing on  the sever 

# save last seen values to animate things in the ui and react to certain milestones
export (float) var last_seen_xp 
export (float) var last_seen_coins
export (float) var last_seen_level 

export (Array) var uncollected_rewards
export (Array) var unplaced_items

func add_reward(reward):
	xp += reward.xp
	coins += reward.coins
	if uncollected_rewards == null: uncollected_rewards = []
	uncollected_rewards.push_back(reward)

func update():
	last_seen_xp = xp 
	last_seen_coins = coins
	last_seen_level = level

func add_item(item): 
	print("added %s" % item.entity_id)
	assert(item.entity_id != null)
	if unplaced_items == null: unplaced_items = []
	unplaced_items.push_back(item)
	
func show_progress(): 
	return {
		"xp": {
			"from": last_seen_xp,
			"to": xp,
			"delta": xp - last_seen_xp, 
		},
		"coins": {
			"from": last_seen_coins,
			"to": coins,
			"delta": xp - last_seen_coins, 
		},
		"level": {
			"from": last_seen_level,
			"to": level,
			"delta": xp - last_seen_level, 
		},
	}
func to_dict(): 
	return {
		"xp": xp ,
		"coins": coins,
		"level": level,
		"last_seen_xp": last_seen_xp, 
		"last_seen_coins": last_seen_coins,
		"last_seen_level": last_seen_level, 
		"uncollected_rewards": Util.flatten_array(uncollected_rewards),
		"unplaced_items": Util.flatten_array(unplaced_items)
	}
