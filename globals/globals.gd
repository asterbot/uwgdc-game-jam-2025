extends Node

var NUM_Z_INDICES = 100

var NO_LAYER = 0b0000
var PROJECTILE_LAYER = 0b0001
var CAT_LAYER = 0b0010
var OBSTACLE_LAYER = 0b0100

var cur_wave = -1
var score = 0

var WAVES = {
	0: {
		"cats": 3,
		"bushes": 2,
		"spawn_cooldown": 5
	},
	1: {
		"cats": 30,
		"bushes": 10,
		"spawn_cooldown": 0.5
	},
	2: {
		"cats": 30,
		"bushes": 10,
		"spawn_cooldown": 0.5
	},
	3: {
		"cats": 30,
		"bushes": 10,
		"spawn_cooldown": 0.5
	},
	4: {
		"cats": 30,
		"bushes": 10,
		"spawn_cooldown": 0.5
	}
	
}

var NUM_WAVES = WAVES.size()

var ALLOWED_BOUNCES = 1 # Number of allowed bounces for each cat
