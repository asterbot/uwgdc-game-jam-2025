extends Node2D

@onready var projectiles_node = %Projectiles
@onready var player_node = %Player
@onready var score_node = %Score

var bush_scene: PackedScene = preload("res://scenes/bush/bush.tscn")
var cat_scene: PackedScene = preload("res://scenes/cat_enemies/cat.tscn")

var viewport_size: Vector2

var can_spawn = true
var enemy_queue: Array = []


func spawn_entities_random(entity_scene: PackedScene, folder: Node2D ,n: int, off_screen: bool = false, use_timer: bool = false):
	"""
	Spawn n random instances of entity_scene in folder of main
	Spawns entity off screen if off_screen is true
	"""
	var width = viewport_size.x
	var height = viewport_size.y
	
	var positions = []
	for i in range(n):
		var position_x = 0
		if (! off_screen): position_x = randf_range(100, width-100)
		else: position_x = [-70, viewport_size.x + 70].pick_random()
		
		var position_y = randf_range(0.43*height, height)
		positions.append(Vector2(position_x, position_y))
	
	for i in range(n):
		var entity = entity_scene.instantiate()
		entity.position = positions[i]
		
		# Add the entity to the queue for spawning
		if (use_timer) : enemy_queue.append(entity)
		else: folder.add_child(entity)

func new_wave():
	"""Call this when a wave change is needed"""
	Globals.cur_wave += 1
	var num_bushes = Globals.WAVES[Globals.cur_wave]["bushes"]
	var num_cats = Globals.WAVES[Globals.cur_wave]["cats"]
	var spawn_cooldown = Globals.WAVES[Globals.cur_wave]["spawn_cooldown"]
	

	$SpawnTimer.wait_time = spawn_cooldown if spawn_cooldown>0 else 0.001
	$SpawnTimer.start()
	
	spawn_entities_random(bush_scene, $Bushes, num_bushes)
	spawn_entities_random(cat_scene, $Enemies, num_cats, true, true)


func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	player_node.projectiles_node = projectiles_node
	$Stage.layer = -1 # background
	new_wave()

func _process(delta: float) -> void:
	viewport_size = get_viewport().get_visible_rect().size
	
	if (!enemy_queue.is_empty() and can_spawn):
		var enemy = enemy_queue.pop_front()
		$Enemies.add_child(enemy)
		can_spawn = false

	if ($Enemies.get_child_count()==0 and enemy_queue.is_empty()):
		# Remove all bushes
		for child in $Bushes.get_children():
			child.destroy()
		
		if (Globals.cur_wave >= Globals.NUM_WAVES - 1):
			# TODO: Win screen
			return
		
		# Instantiate new wave
		new_wave()


func _on_projectiles_child_entered_tree(projectile: CharacterBody2D) -> void:
	# when projectile enters this folder, connect its signal to it
	projectile.connect("notify_cat_hit", score_node.increment_score)


func _on_spawn_timer_timeout() -> void:
	$SpawnTimer.start()
	can_spawn = true
