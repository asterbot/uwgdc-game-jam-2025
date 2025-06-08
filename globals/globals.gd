extends Node

var NUM_Z_INDICES = 100

var NO_LAYER = 0b0000
var PROJECTILE_LAYER = 0b0001
var CAT_LAYER = 0b0010
var OBSTACLE_LAYER = 0b0100

var cur_wave = 0
var score = 0

var WAVES = {
	0: {
		"cats": 300,
		"bushes": 5
	}
}
