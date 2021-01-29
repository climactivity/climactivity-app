extends Resource

export (String) var aspect
export (int) var time_stamp 
export (float) var level 
export (float) var value 
export (Resource) var reward
#"set_at": time_stamp,
#"level?": level, # <- int falls discrete werte, float(0,1) falls contiuum
#"reward": reward,
#"value?": value
