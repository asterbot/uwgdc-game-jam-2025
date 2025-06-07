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
	
	
	for proj in projectiles_in_range:
		#print("TIME: ", proj.time) # 0 to 1, based on depth
		
		var time_left_normalized: float = proj.timer.time_left/proj.time
		if time_left_normalized > 0 and \
				time_left_normalized < depth and depth < time_left_normalized + 0.3:
			print("Damage! OUCHIE! SPLAT")
			proj.queue_free()
			break


func _on_area_2d_area_entered(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.append(projectile)


func _on_area_2d_area_exited(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.erase(projectile)
