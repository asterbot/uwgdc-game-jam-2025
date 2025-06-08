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
		"ground_cats": 0,
		"balloon_cats": 5,
		"bushes": 0,
		"spawn_cooldown": 1
	},
	1: {
		"ground_cats": 4,
		"balloon_cats": 0,
		"bushes": 3,
		"spawn_cooldown": 2.5
	},
	2: {
		"ground_cats": 8,
		"balloon_cats": 2,
		"bushes": 5,
		"spawn_cooldown": 2
	},
	3: {
		"ground_cats": 15,
		"balloon_cats": 6,
		"bushes": 7,
		"spawn_cooldown": 1.5
	},
	4: {
		"ground_cats": 25,
		"balloon_cats": 11,
		"bushes": 10,
		"spawn_cooldown": 1
	},
	5: {
		"ground_cats": 0,
		"balloon_cats": 18,
		"bushes": 0,
		"spawn_cooldown": 0.75
	},
	6: {
		"ground_cats": 30,
		"balloon_cats": 0,
		"bushes": 13,
		"spawn_cooldown": 0.75
	},
	7: {
		"ground_cats": 40,
		"balloon_cats": 25,
		"bushes": 15,
		"spawn_cooldown": 0.5
	},
}

var NUM_WAVES = WAVES.size()

var ALLOWED_BOUNCES = 1 # Number of allowed bounces for each cat
