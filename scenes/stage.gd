extends CanvasLayer

var bush_scene: PackedScene = preload("res://scenes/bush.tscn")

func choose_random_numbers(lower: int, upper: int, n: int):
	"""Return list of n random numbers in the range [lower,upper]"""
	var nums = []
	randomize()
	
	while nums.size() < n:
		var num = randi() % (upper - lower + 1) + lower
		nums.append(num)
	
	return nums


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var width = viewport_size.x
	var height = viewport_size.y
	
	var num_bushes = 4
	var bush_positions_y = choose_random_numbers(height/2,height,num_bushes)
	var bush_positions_x = choose_random_numbers(0, width, num_bushes)
	for i in range(num_bushes):
		var bush = bush_scene.instantiate()
		bush.position = Vector2(bush_positions_x[i], bush_positions_y[i])
		bush.z_index = -1 # TODO: not sure about this
		add_child(bush)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
