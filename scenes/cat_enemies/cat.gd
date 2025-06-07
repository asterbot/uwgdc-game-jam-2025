class_name Cat

extends CharacterBody2D

var projectiles_in_range = []
var depth: float

var viewport_size: Vector2

var velocity_x = randf_range(300,350)

var color_options = {
	"default": Color(1,1,1),
	"red": Color(1,0,1),
	"green": Color(0,1,1),
	"devil": Color(1, 0.5, 1)
}

func _ready() -> void:
	random_modulate()
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	velocity_x *= depth
	
func _process(_delta: float) -> void:
	# set scale based on depth (i.e by y-coord)
	$AnimationPlayer.play("dance")
	
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	self.scale = Vector2(depth, depth)
	
	self.z_index = floor(depth*Globals.NUM_Z_INDICES)
	
	for proj in projectiles_in_range:
		if proj.time_left_normalized > 0 and \
			proj.time_left_normalized < depth and depth < proj.time_left_normalized + 0.3:
			print("Damage! OUCHIE! SPLAT")
			proj.queue_free()
			break

	velocity.x = velocity_x
	move_and_slide()
	
	# If out of bounds, bounce back in
	if (position.x < 10):
		velocity_x = abs(velocity_x)
	elif (position.x > get_viewport().get_visible_rect().size.x - 10):
		velocity_x = -abs(velocity_x)

func random_modulate():
	var colors_size = color_options.size()
	var random_key  = color_options.keys()[randi() % colors_size]
	$CatSprite.modulate = color_options[random_key]


func _on_area_2d_area_entered(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.append(projectile)


func _on_area_2d_area_exited(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.erase(projectile)
