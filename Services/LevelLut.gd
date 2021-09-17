extends Node
var levels = {
	1: {"xp": 500, "xp_total": 500, "bonus_coins": 5},
	2: {"xp": 1000, "xp_total": 1500, "bonus_coins": 5},
	3: {"xp": 1500, "xp_total": 3000, "bonus_coins": 5},
	4: {"xp": 2000, "xp_total": 5000, "bonus_coins": 5},
	5: {"xp": 2500, "xp_total": 7500, "bonus_coins": 10},
	6: {"xp": 3000, "xp_total": 10500, "bonus_coins": 5},
	7: {"xp": 3500, "xp_total": 14000, "bonus_coins": 5},
	8: {"xp": 4000, "xp_total": 18000, "bonus_coins": 5},
	9: {"xp": 4500, "xp_total": 22500, "bonus_coins": 5},
	10: {"xp": 5000, "xp_total": 27500, "bonus_coins": 20},
	11: {"xp": 5500, "xp_total": 33000, "bonus_coins": 5},
	12: {"xp": 6000, "xp_total": 39000, "bonus_coins": 5},
	13: {"xp": 6500, "xp_total": 45500, "bonus_coins": 5},
	14: {"xp": 7000, "xp_total": 52500, "bonus_coins": 5},
	15: {"xp": 7500, "xp_total": 60000, "bonus_coins": 10},
	16: {"xp": 8000, "xp_total": 68000, "bonus_coins": 5},
	17: {"xp": 8500, "xp_total": 76500, "bonus_coins": 5},
	18: {"xp": 9000, "xp_total": 85500, "bonus_coins": 5},
	19: {"xp": 9500, "xp_total": 95000, "bonus_coins": 5},
	20: {"xp": 10000, "xp_total": 105000, "bonus_coins": 20},
	21: {"xp": 10500, "xp_total": 115500, "bonus_coins": 5},
	22: {"xp": 11000, "xp_total": 126500, "bonus_coins": 5},
	23: {"xp": 11500, "xp_total": 138000, "bonus_coins": 5},
	24: {"xp": 12000, "xp_total": 150000, "bonus_coins": 5},
	25: {"xp": 12500, "xp_total": 162500, "bonus_coins": 10},
	26: {"xp": 13000, "xp_total": 175500, "bonus_coins": 5},
	27: {"xp": 13500, "xp_total": 189000, "bonus_coins": 5},
	28: {"xp": 14000, "xp_total": 203000, "bonus_coins": 5},
	29: {"xp": 14500, "xp_total": 217500, "bonus_coins": 5},
	30: {"xp": 15000, "xp_total": 232500, "bonus_coins": 20},
	31: {"xp": 15500, "xp_total": 248000, "bonus_coins": 5},
	32: {"xp": 16000, "xp_total": 264000, "bonus_coins": 5},
	33: {"xp": 16500, "xp_total": 280500, "bonus_coins": 5},
	34: {"xp": 17000, "xp_total": 297500, "bonus_coins": 5},
	35: {"xp": 17500, "xp_total": 315000, "bonus_coins": 10},
	36: {"xp": 18000, "xp_total": 333000, "bonus_coins": 5},
	37: {"xp": 18500, "xp_total": 351500, "bonus_coins": 5},
	38: {"xp": 19000, "xp_total": 370500, "bonus_coins": 5},
	39: {"xp": 19500, "xp_total": 390000, "bonus_coins": 5},
	40: {"xp": 20000, "xp_total": 410000, "bonus_coins": 20},
	41: {"xp": 20500, "xp_total": 430500, "bonus_coins": 5},
	42: {"xp": 21000, "xp_total": 451500, "bonus_coins": 5},
	43: {"xp": 21500, "xp_total": 473000, "bonus_coins": 5},
	44: {"xp": 22000, "xp_total": 495000, "bonus_coins": 5},
	45: {"xp": 22500, "xp_total": 517500, "bonus_coins": 10},
	46: {"xp": 23000, "xp_total": 540500, "bonus_coins": 5},
	47: {"xp": 23500, "xp_total": 564000, "bonus_coins": 5},
	48: {"xp": 24000, "xp_total": 588000, "bonus_coins": 5},
	49: {"xp": 24500, "xp_total": 612500, "bonus_coins": 5},
	50: {"xp": 25000, "xp_total": 637500, "bonus_coins": 20},
	51: {"xp": 25500, "xp_total": 663000, "bonus_coins": 5},
	52: {"xp": 26000, "xp_total": 689000, "bonus_coins": 5},
	53: {"xp": 26500, "xp_total": 715500, "bonus_coins": 5},
	54: {"xp": 27000, "xp_total": 742500, "bonus_coins": 5},
	55: {"xp": 27500, "xp_total": 770000, "bonus_coins": 10},
	56: {"xp": 28000, "xp_total": 798000, "bonus_coins": 5},
	57: {"xp": 28500, "xp_total": 826500, "bonus_coins": 5},
	58: {"xp": 29000, "xp_total": 855500, "bonus_coins": 5},
	59: {"xp": 29500, "xp_total": 885000, "bonus_coins": 5},
	60: {"xp": 30000, "xp_total": 915000, "bonus_coins": 20},
	61: {"xp": 30500, "xp_total": 945500, "bonus_coins": 5},
	62: {"xp": 31000, "xp_total": 976500, "bonus_coins": 5},
	63: {"xp": 31500, "xp_total": 1008000, "bonus_coins": 5},
	64: {"xp": 32000, "xp_total": 1040000, "bonus_coins": 5},
	65: {"xp": 32500, "xp_total": 1072000, "bonus_coins": 10},
	66: {"xp": 33000, "xp_total": 1105000, "bonus_coins": 5},
	67: {"xp": 33500, "xp_total": 1139000, "bonus_coins": 5},
	68: {"xp": 34000, "xp_total": 1173000, "bonus_coins": 5},
	69: {"xp": 34500, "xp_total": 1207000, "bonus_coins": 5},
	70: {"xp": 35000, "xp_total": 1242000, "bonus_coins": 20},
	71: {"xp": 35500, "xp_total": 1278000, "bonus_coins": 5},
	72: {"xp": 36000, "xp_total": 1314000, "bonus_coins": 5},
	73: {"xp": 36500, "xp_total": 1350000, "bonus_coins": 5},
	74: {"xp": 37000, "xp_total": 1387000, "bonus_coins": 5},
	75: {"xp": 37500, "xp_total": 1425000, "bonus_coins": 10},
	76: {"xp": 38000, "xp_total": 1463000, "bonus_coins": 5},
	77: {"xp": 38500, "xp_total": 1501000, "bonus_coins": 5},
	78: {"xp": 39000, "xp_total": 1540000, "bonus_coins": 5},
	79: {"xp": 39500, "xp_total": 1580000, "bonus_coins": 5},
	80: {"xp": 40000, "xp_total": 1620000, "bonus_coins": 20},
	81: {"xp": 40500, "xp_total": 1660000, "bonus_coins": 5},
	82: {"xp": 41000, "xp_total": 1701000, "bonus_coins": 5},
	83: {"xp": 41500, "xp_total": 1743000, "bonus_coins": 5},
	84: {"xp": 42000, "xp_total": 1785000, "bonus_coins": 5},
	85: {"xp": 42500, "xp_total": 1827000, "bonus_coins": 10},
	86: {"xp": 43000, "xp_total": 1870000, "bonus_coins": 5},
	87: {"xp": 43500, "xp_total": 1914000, "bonus_coins": 5},
	88: {"xp": 44000, "xp_total": 1958000, "bonus_coins": 5},
	89: {"xp": 44500, "xp_total": 2002000, "bonus_coins": 5},
	90: {"xp": 45000, "xp_total": 2047000, "bonus_coins": 20},
	91: {"xp": 45500, "xp_total": 2093000, "bonus_coins": 5},
	92: {"xp": 46000, "xp_total": 2139000, "bonus_coins": 5},
	93: {"xp": 46500, "xp_total": 2185000, "bonus_coins": 5},
	94: {"xp": 47000, "xp_total": 2232000, "bonus_coins": 5},
	95: {"xp": 47500, "xp_total": 2280000, "bonus_coins": 10},
	96: {"xp": 48000, "xp_total": 2328000, "bonus_coins": 5},
	97: {"xp": 48500, "xp_total": 2376000, "bonus_coins": 5},
	98: {"xp": 49000, "xp_total": 2425000, "bonus_coins": 5},
	99: {"xp": 49500, "xp_total": 2475000, "bonus_coins": 5},
	100: {"xp": 50000, "xp_total": 2525000, "bonus_coins": 20}
}

func get_level(xp): 
	for key in levels.keys(): 
		var _level = levels[key]
		if _level.xp_total > xp:
			return key 
			
func get_level_by_level(_lvl):
	if !levels.has(_lvl):
		return null
	else:
		return levels[_lvl]

func get_frac(xp): 
	var level = get_level(xp)
	var frac = 0.0
	if level == 1:
		frac = float(xp/levels[1].xp)
	else: 
		var prev_level = level - 1 
#		var teiler = 
#		var nenner =  - levels[prev_level].xp
		frac = float(xp - levels[prev_level].xp_total )/ float(levels[level].xp)
	Logger.print( str(frac), self)
	return frac
