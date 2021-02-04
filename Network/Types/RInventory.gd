extends Resource

export (float) var xp
export (float) var coins 
export (float) var level # todo do things with that, also needs a levelup table thing on  the sever 

# save last seen values to animate things in the ui and react to certain milestones
export (float) var last_seen_xp 
export (float) var last_seen_coins
export (float) var last_seen_level 

func add_reward(reward):
    xp += reward.xp
    coins += reward.coins

func update():
    last_seen_xp = xp 
    last_seen_coins = coins
    last_seen_level = level

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