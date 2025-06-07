extends Node2D

@onready var projectiles_node = %Projectiles
@onready var player_node = %Player

var bush_scene: PackedScene = preload("res://scenes/bush/bush.tscn")
var cat_scene: PackedScene = preload("res://scenes/cat_enemies/cat.tscn")


func choose_random_numbers(lower: int, upper: int, n: int, min_gap: int = 40) -> Array:
	"""Returns n random numbers in range [lower,upper] with at least min_gap between all of them"""
	
	var max_possible = floor((upper - lower) / min_gap) + 1 # max qty numbers that may exist
	if n > max_possible:
		assert(false, "Not enough room for numbers with this min_gap.")

	var possible_positions = []
	for i in range(max_possible):
		possible_positions.append(lower + i * min_gap) # uniformly get all numbers with gap min_gap

	possible_positions.shuffle()
	return possible_positions.slice(0, n) # take first n numbers after shuffling

func spawn_entities_random(entity_scene: PackedScene, folder: Node2D ,n: int):
	"""Spawn n random instances of entity_scene in folder of main with given z_index (default 10)"""
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var width = viewport_size.x
	var height = viewport_size.y
	
	# These ranges should roughly be the places in the field
	var entity_positions_y = choose_random_numbers(height/2,height-200, n, 80)
	var entity_positions_x = choose_random_numbers(40, width-40, n)
	for i in range(n):
		var entity = entity_scene.instantiate()
		entity.position = Vector2(entity_positions_x[i], entity_positions_y[i])
		folder.add_child(entity)
	

func new_wave():
	"""Call this after doing Globals.cur_wave+=1 whenever a wave change is needed"""
	var num_bushes = Globals.WAVES[Globals.cur_wave]["bushes"]
	var num_cats = Globals.WAVES[Globals.cur_wave]["cats"]
	spawn_entities_random(bush_scene, $Bushes, num_bushes)
	spawn_entities_random(cat_scene, $Enemies, num_cats)
	

func _ready() -> void:
	player_node.projectiles_node = projectiles_node
	$Stage.layer = -1
	new_wave()

func _process(delta: float) -> void:
	pass
