class_name Cat

extends CharacterBody2D

var projectiles_in_range = []
var depth: float

var viewport_size: Vector2


func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	# set scale based on depth (i.e by y-coord)
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


func _on_area_2d_area_entered(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.append(projectile)


func _on_area_2d_area_exited(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.erase(projectile)
