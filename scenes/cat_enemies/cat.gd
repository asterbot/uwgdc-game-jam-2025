class_name Cat

extends CharacterBody2D

var raw_velocity: Vector2 = Vector2.ZERO
var depth: float

var viewport_size: Vector2

var dying: bool = false

@onready var stink_line_material = $StinkLines.material
var stink_final_alpha: float = 1.0
@onready var cat_colour_material = $CatSprite.material

var num_bounces = 0

var can_bounce = false

var color_options = {
	"orange": load("res://assets/cat_enemy/palette_1.png")
}


func _ready() -> void:
	$Area2D.collision_layer = Globals.CAT_LAYER
	$Area2D.collision_mask = Globals.NO_LAYER
	
	var colors_map_size = color_options.size()
	var random_key = color_options.keys()[randi() % colors_map_size]
	cat_colour_material.set_shader_parameter("palette", color_options[random_key])
	
	
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	raw_velocity.x = randf_range(400, 600) * [-1, 1].pick_random()
	
	stink_line_material.set_shader_parameter("final_alpha", stink_final_alpha)
	
func _process(_delta: float) -> void:
	# set scale based on depth (i.e by y-coord)
	stink_line_material.set_shader_parameter("final_alpha", stink_final_alpha)
	
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	self.scale = Vector2(depth, depth)
	
	if not dying:
		self.z_index = floor(depth*Globals.NUM_Z_INDICES)
	else:
		self.z_index = Globals.NUM_Z_INDICES + 1 # make death animation visible above everything
	
	velocity = raw_velocity * depth
	move_and_slide()
	
	if (position.x >= -70 and position.x <= viewport_size.x + 70):
		# If it's in the playing field, it can bounce
		can_bounce = true
	
	# If out of bounds, bounce back in
	if (position.x < -70):
		raw_velocity.x = abs(raw_velocity.x)
		if (can_bounce): num_bounces+=1
	elif (position.x > viewport_size.x + 70):
		raw_velocity.x = -abs(raw_velocity.x)
		if (can_bounce): num_bounces+=1
	
	if (num_bounces > Globals.ALLOWED_BOUNCES):
		destroy()

func destroy() -> void:
	dying = true
	$Area2D/CollisionShape2D.disabled = true
	raw_velocity = Vector2(0, randf_range(-800, -2000))
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($GPUParticles2D, "modulate:a", 0.0, 0.5)
	tween.tween_property(self, "stink_final_alpha", 0.0, 0.5)
	tween.tween_property($CatSprite, "rotation_degrees", 1080, 1.0).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	queue_free()
