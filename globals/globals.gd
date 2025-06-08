extends Node

var transition_alpha = 0.0

var NUM_Z_INDICES = 100

var NO_LAYER = 0b0000
var PROJECTILE_LAYER = 0b0001
var CAT_LAYER = 0b0010
var OBSTACLE_LAYER = 0b0100
var BALLOON_LAYER = 0b1000

var cur_wave = -1
var score = 0

var WAVES = {
	0: {
		"ground_cats": 4,
		"balloon_cats": 0,
		"bushes": 0,
		"spawn_cooldown": 3
	},
	1: {
		"ground_cats": 4,
		"balloon_cats": 0,
		"bushes": 6,
		"spawn_cooldown": 2.5
	},
	2: {
		"ground_cats": 8,
		"balloon_cats": 2,
		"bushes": 8,
		"spawn_cooldown": 2
	},
	3: {
		"ground_cats": 20,
		"balloon_cats": 6,
		"bushes": 9,
		"spawn_cooldown": 1.5
	},
	4: {
		"ground_cats": 30,
		"balloon_cats": 10,
		"bushes": 10,
		"spawn_cooldown": 1
	}
}

var NUM_WAVES = WAVES.size()

var ALLOWED_BOUNCES = 1 # Number of allowed bounces for each cat
